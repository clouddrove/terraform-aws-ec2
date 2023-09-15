##----------------------------------------------------------------------------------
## Labels module callled that will be used for naming and tags.
##----------------------------------------------------------------------------------
module "labels" {
  source      = "clouddrove/labels/aws"
  version     = "1.3.0"
  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}

locals {
  ebs_iops = var.ebs_volume_type == "io1" || var.ebs_volume_type == "io2" || var.ebs_volume_type == "gp3" ? var.ebs_iops : 0
}

data "aws_ami" "ubuntu" {
  most_recent = "true"
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

##----------------------------------------------------------------------------------
## resource for generating or importing an SSH public key file into AWS.
##----------------------------------------------------------------------------------
resource "tls_private_key" "default" {
  count     = var.enable && var.public_key == "" && var.enable_key_pair ? 1 : 0
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

resource "aws_key_pair" "default" {
  count      = var.enable && var.enable_key_pair == true ? 1 : 0
  key_name   = format("%s-key-pair", module.labels.id)
  public_key = var.public_key == "" ? join("", tls_private_key.default[*].public_key_openssh) : var.public_key
  tags       = module.labels.tags
}


##----------------------------------------------------------------------------------
## Below resources will create SECURITY-GROUP and its components.
##----------------------------------------------------------------------------------
resource "aws_security_group" "default" {
  count       = var.enable && var.enable_security_group && length(var.sg_ids) < 1 ? 1 : 0
  name        = format("%s-sg", module.labels.id)
  vpc_id      = var.vpc_id
  description = var.sg_description
  tags        = module.labels.tags
  lifecycle {
    create_before_destroy = true
  }
}

##----------------------------------------------------------------------------------
## Below resources will create SECURITY-GROUP-RULE and its components.
##----------------------------------------------------------------------------------
#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "egress_ipv4" {
  count             = (var.enable && var.enable_security_group && length(var.sg_ids) < 1 && var.is_external == false && var.egress_rule) ? 1 : 0
  description       = var.sg_egress_description
  type              = "egress"
  from_port         = var.egress_ipv4_from_port
  to_port           = var.egress_ipv4_to_port
  protocol          = var.egress_ipv4_protocol
  cidr_blocks       = var.egress_ipv4_cidr_block
  security_group_id = join("", aws_security_group.default[*].id)
}
#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "egress_ipv6" {
  count             = var.enable && var.enable_security_group && length(var.sg_ids) < 1 && var.is_external == false && var.egress_rule ? 1 : 0
  description       = var.sg_egress_ipv6_description
  type              = "egress"
  from_port         = var.egress_ipv6_from_port
  to_port           = var.egress_ipv6_to_port
  protocol          = var.egress_ipv6_protocol
  ipv6_cidr_blocks  = var.egress_ipv6_cidr_block
  security_group_id = join("", aws_security_group.default[*].id)
}
#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "ssh_ingress" {
  count             = var.enable && length(var.ssh_allowed_ip) > 0 && length(var.sg_ids) < 1 ? length(compact(var.ssh_allowed_ports)) : 0
  description       = var.ssh_sg_ingress_description
  type              = "ingress"
  from_port         = element(var.ssh_allowed_ports, count.index)
  to_port           = element(var.ssh_allowed_ports, count.index)
  protocol          = var.ssh_protocol
  cidr_blocks       = var.ssh_allowed_ip
  security_group_id = join("", aws_security_group.default[*].id)
}
#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "ingress" {
  count = var.enable && length(var.allowed_ip) > 0 && length(var.sg_ids) < 1 ? length(compact(var.allowed_ports)) : 0

  description       = var.sg_ingress_description
  type              = "ingress"
  from_port         = element(var.allowed_ports, count.index)
  to_port           = element(var.allowed_ports, count.index)
  protocol          = var.protocol
  cidr_blocks       = var.allowed_ip
  security_group_id = join("", aws_security_group.default[*].id)
}

##----------------------------------------------------------------------------------
## Below resources will create KMS-KEY and its components.
##----------------------------------------------------------------------------------
resource "aws_kms_key" "default" {
  count                    = var.enable && var.kms_key_enabled && var.kms_key_id == "" ? 1 : 0
  description              = var.kms_description
  key_usage                = var.key_usage
  deletion_window_in_days  = var.deletion_window_in_days
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation
  customer_master_key_spec = var.customer_master_key_spec
  policy                   = data.aws_iam_policy_document.kms.json
  multi_region             = var.kms_multi_region
  tags                     = module.labels.tags
}

data "aws_caller_identity" "this" {}

resource "aws_kms_alias" "default" {
  count         = var.enable && var.kms_key_enabled && var.kms_key_id == "" ? 1 : 0
  name          = coalesce(var.alias, format("alias/%v", module.labels.id))
  target_key_id = var.kms_key_id == "" ? join("", aws_kms_key.default[*].id) : var.kms_key_id
}

data "aws_iam_policy_document" "kms" {
  version = "2012-10-17"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [format("arn:aws:iam::%s:root", data.aws_caller_identity.this.account_id)]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

##----------------------------------------------------------------------------------
## Below Terraform module to create an EC2 resource on AWS with Elastic IP Addresses and Elastic Block Store.
##----------------------------------------------------------------------------------
#tfsec:ignore:aws-ec2-enforce-http-token-imds
resource "aws_instance" "default" {
  count                                = var.enable && var.default_instance_enabled ? var.instance_count : 0
  ami                                  = var.ami == "" ? data.aws_ami.ubuntu.id : var.ami
  ebs_optimized                        = var.ebs_optimized
  instance_type                        = var.instance_type
  key_name                             = var.key_name == "" ? join("", aws_key_pair.default[*].key_name) : var.key_name
  monitoring                           = var.monitoring
  vpc_security_group_ids               = length(var.sg_ids) < 1 ? aws_security_group.default[*].id : var.sg_ids
  subnet_id                            = element(distinct(compact(concat(var.subnet_ids))), count.index)
  associate_public_ip_address          = var.associate_public_ip_address
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy
  host_id                              = var.host_id
  cpu_core_count                       = var.cpu_core_count
  cpu_threads_per_core                 = var.cpu_threads_per_core
  user_data                            = var.user_data
  user_data_base64                     = var.user_data_base64
  user_data_replace_on_change          = var.user_data_replace_on_change
  availability_zone                    = var.availability_zone
  get_password_data                    = var.get_password_data
  private_ip                           = var.private_ip
  secondary_private_ips                = var.secondary_private_ips
  iam_instance_profile                 = join("", aws_iam_instance_profile.default[*].name)
  source_dest_check                    = var.source_dest_check
  ipv6_address_count                   = var.ipv6_address_count
  ipv6_addresses                       = var.ipv6_addresses
  hibernation                          = var.hibernation
  dynamic "cpu_options" {
    for_each = length(var.cpu_options) > 0 ? [var.cpu_options] : []
    content {
      core_count       = lookup(cpu_options, "core_count", null)
      threads_per_core = lookup(cpu_options, "threads_per_core", null)
      amd_sev_snp      = lookup(cpu_options, "amd_sev_snp", null)
    }
  }

  dynamic "capacity_reservation_specification" {
    for_each = length(var.capacity_reservation_specification) > 0 ? [var.capacity_reservation_specification] : []
    content {
      capacity_reservation_preference = lookup(capacity_reservation_specification, "capacity_reservation_preference", null)
      dynamic "capacity_reservation_target" {
        for_each = lookup(capacity_reservation_specification, "capacity_reservation_target", [])
        content {
          capacity_reservation_id                 = try(capacity_reservation_target, "capacity_reservation_id", null)
          capacity_reservation_resource_group_arn = try(capacity_reservation_target, "capacity_reservation_resource_group_arn", null)
        }
      }
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = true
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = var.kms_key_id == "" ? join("", aws_kms_key.default[*].arn) : lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      tags = merge(module.labels.tags,
        {
          "Name" = format("%s-root-volume%s%s", module.labels.id, var.delimiter, (count.index))
        },
        var.tags
      )
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = var.kms_key_id == "" ? join("", aws_kms_key.default[*].arn) : lookup(root_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
      tags = merge(module.labels.tags,
        {
          "Name" = format("%s%s%s", module.labels.id, var.delimiter, (count.index))
        }, { "device_name" = ebs_block_device.value.device_name },
        var.instance_tags
      )
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  metadata_options {
    http_endpoint               = var.metadata_http_endpoint_enabled
    instance_metadata_tags      = var.instance_metadata_tags_enabled
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    http_tokens                 = var.metadata_http_tokens_required
  }

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }

  dynamic "launch_template" {
    for_each = length(var.launch_template) > 0 ? [var.launch_template] : []
    content {
      id      = lookup(var.launch_template, "id", null)
      name    = lookup(var.launch_template, "name", null)
      version = lookup(var.launch_template, "version", null)
    }
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
  }

  enclave_options {
    enabled = var.enclave_options_enabled
  }

  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s%s%s", module.labels.id, var.delimiter, (count.index))
    },
    var.instance_tags
  )

  lifecycle {
    # Due to several known issues in Terraform AWS provider related to arguments of aws_instance:
    # (eg, https://github.com/terraform-providers/terraform-provider-aws/issues/2036)
    # we have to ignore changes in the following arguments
    ignore_changes = [
      private_ip,
    ]
  }
}

##----------------------------------------------------------------------------------
## Provides an Elastic IP resource..
##----------------------------------------------------------------------------------
resource "aws_eip" "default" {
  count             = var.enable && var.assign_eip_address ? var.instance_count : 0
  network_interface = element(aws_instance.default[*].primary_network_interface_id, count.index)
  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s%s%s-eip", module.labels.id, var.delimiter, (count.index))
    }
  )
}

##----------------------------------------------------------------------------------
## Manages a single EBS volume.
##----------------------------------------------------------------------------------
resource "aws_ebs_volume" "default" {
  count                = var.enable && var.ebs_volume_enabled ? var.instance_count : 0
  availability_zone    = element(aws_instance.default[*].availability_zone, count.index)
  size                 = var.ebs_volume_size
  iops                 = local.ebs_iops
  type                 = var.ebs_volume_type
  multi_attach_enabled = var.multi_attach_enabled
  encrypted            = true
  kms_key_id           = var.kms_key_id == "" ? join("", aws_kms_key.default[*].arn) : var.kms_key_id
  tags = merge(module.labels.tags,
    { "Name" = format("%s-ebs-volume%s%s", module.labels.id, var.delimiter, (count.index))
    },
    var.tags
  )
  depends_on = [aws_instance.default]
}

##----------------------------------------------------------------------------------
## Provides an AWS EBS Volume Attachment as a top level resource, to attach and detach volumes from AWS Instances.
##----------------------------------------------------------------------------------
resource "aws_volume_attachment" "default" {
  count       = var.enable && var.ebs_volume_enabled ? var.instance_count : 0
  device_name = element(var.ebs_device_name, count.index)
  volume_id   = element(aws_ebs_volume.default[*].id, count.index)
  instance_id = element(aws_instance.default[*].id, count.index)
  depends_on  = [aws_instance.default]
}

##----------------------------------------------------------------------------------
## Provides an IAM instance profile.
##----------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "default" {
  count = var.enable && var.instance_profile_enabled ? 1 : 0
  name  = format("%s%sinstance-profile", module.labels.id, var.delimiter)
  role  = var.iam_instance_profile
}

##----------------------------------------------------------------------------------
## Below resource will create ROUTE-53 resource for memcached.
##----------------------------------------------------------------------------------
resource "aws_route53_record" "default" {
  count   = var.enable && var.dns_enabled ? var.instance_count : 0
  zone_id = var.dns_zone_id
  name    = format("%s%s%s", var.hostname, var.delimiter, (count.index))
  type    = var.type
  ttl     = var.ttl
  records = [element(aws_instance.default[*].private_dns, count.index)]
}

##----------------------------------------------------------------------------------
## Below Provides an EC2 Spot Instance Request resource. This allows instances to be requested on the spot market..
##----------------------------------------------------------------------------------
resource "aws_spot_instance_request" "default" {
  count                                = var.enable && var.spot_instance_enabled ? var.spot_instance_count : 0
  spot_price                           = var.spot_price
  wait_for_fulfillment                 = var.spot_wait_for_fulfillment
  spot_type                            = var.spot_type
  launch_group                         = var.spot_launch_group
  block_duration_minutes               = var.spot_block_duration_minutes
  instance_interruption_behavior       = var.spot_instance_interruption_behavior
  valid_until                          = var.spot_valid_until
  valid_from                           = var.spot_valid_from
  ami                                  = var.ami == "" ? data.aws_ami.ubuntu.id : var.ami
  ebs_optimized                        = var.ebs_optimized
  instance_type                        = var.instance_type
  key_name                             = var.key_name == "" ? join("", aws_key_pair.default[*].key_name) : var.key_name
  monitoring                           = var.monitoring
  vpc_security_group_ids               = length(var.sg_ids) < 1 ? aws_security_group.default[*].id : var.sg_ids
  subnet_id                            = element(distinct(compact(concat(var.subnet_ids))), count.index)
  associate_public_ip_address          = var.associate_public_ip_address
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy
  host_id                              = var.host_id
  cpu_core_count                       = var.cpu_core_count
  cpu_threads_per_core                 = var.cpu_threads_per_core
  user_data                            = var.user_data
  user_data_base64                     = var.user_data_base64
  user_data_replace_on_change          = var.user_data_replace_on_change
  availability_zone                    = var.availability_zone
  get_password_data                    = var.get_password_data
  private_ip                           = var.private_ip
  secondary_private_ips                = var.secondary_private_ips
  iam_instance_profile                 = join("", aws_iam_instance_profile.default[*].name)
  source_dest_check                    = var.source_dest_check
  ipv6_address_count                   = var.ipv6_address_count
  ipv6_addresses                       = var.ipv6_addresses
  hibernation                          = var.hibernation

  dynamic "cpu_options" {
    for_each = length(var.cpu_options) > 0 ? [var.cpu_options] : []
    content {
      core_count       = lookup(cpu_options, "core_count", null)
      threads_per_core = lookup(cpu_options, "threads_per_core", null)
      amd_sev_snp      = lookup(cpu_options, "amd_sev_snp", null)
    }
  }

  dynamic "capacity_reservation_specification" {
    for_each = length(var.capacity_reservation_specification) > 0 ? [var.capacity_reservation_specification] : []
    content {
      capacity_reservation_preference = lookup(capacity_reservation_specification, "capacity_reservation_preference", null)
      dynamic "capacity_reservation_target" {
        for_each = lookup(capacity_reservation_specification, "capacity_reservation_target", [])
        content {
          capacity_reservation_id                 = try(capacity_reservation_target, "capacity_reservation_id", null)
          capacity_reservation_resource_group_arn = try(capacity_reservation_target, "capacity_reservation_resource_group_arn", null)
        }
      }
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = true
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = var.kms_key_id == "" ? join("", aws_kms_key.default[*].arn) : lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      tags = merge(module.labels.tags,
        {
          "Name" = format("%s-root-volume%s%s", module.labels.id, var.delimiter, (count.index))
        },
        var.tags
      )
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = var.kms_key_id == "" ? join("", aws_kms_key.default[*].arn) : lookup(root_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
      tags = merge(module.labels.tags,
        {
          "Name" = format("%s%s%s", module.labels.id, var.delimiter, (count.index))
        }, { "device_name" = ebs_block_device.value.device_name },
        var.instance_tags
      )
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  metadata_options {
    http_endpoint               = var.metadata_http_endpoint_enabled
    instance_metadata_tags      = var.instance_metadata_tags_enabled
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    http_tokens                 = var.metadata_http_tokens_required
  }

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }

  dynamic "launch_template" {
    for_each = length(var.launch_template) > 0 ? [var.launch_template] : []
    content {
      id      = lookup(var.launch_template, "id", null)
      name    = lookup(var.launch_template, "name", null)
      version = lookup(var.launch_template, "version", null)
    }
  }

  enclave_options {
    enabled = var.enclave_options_enabled
  }

  timeouts {
    create = try(var.timeouts.create, null)
    delete = try(var.timeouts.delete, null)
  }

  tags = merge(
    module.labels.tags,
    {

      "Name" = format("%s%s%s", module.labels.id, var.delimiter, (count.index))
    },
    var.spot_instance_tags
  )

  lifecycle {
    # Due to several known issues in Terraform AWS provider related to arguments of aws_instance:
    # (eg, https://github.com/terraform-providers/terraform-provider-aws/issues/2036)
    # we have to ignore changes in the following arguments
    ignore_changes = [
      private_ip,
    ]
  }
}