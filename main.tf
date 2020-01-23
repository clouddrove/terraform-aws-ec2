# Managed By : CloudDrove
# Description : This Script is used to create EC2, EIP, EBS VOLUME,  and VOLUME ATTACHMENT.
# Copyright @ CloudDrove. All Right Reserved.

#Module      : Label
#Description : This terraform module is designed to generate consistent label names and #              tags for resources. You can use terraform-labels to implement a strict #              naming convention.
module "labels" {
  source = "git::https://github.com/clouddrove/terraform-labels.git?ref=tags/0.12.0"

  name        = var.name
  application = var.application
  environment = var.environment
  label_order = var.label_order
}

locals {
  ebs_iops = var.ebs_volume_type == "io1" ? var.ebs_iops : 0
}


#Module      : EC2
#Description : Terraform module to create an EC2 resource on AWS with Elastic IP Addresses
#              and Elastic Block Store.
resource "aws_instance" "default" {
  count = var.instance_enabled == true ? var.instance_count : 0

  ami                                  = var.ami
  ebs_optimized                        = var.ebs_optimized
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  monitoring                           = var.monitoring
  vpc_security_group_ids               = var.vpc_security_group_ids_list
  subnet_id                            = element(distinct(compact(concat(var.subnet_ids))), count.index)
  associate_public_ip_address          = var.associate_public_ip_address
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy
  host_id                              = var.host_id
  cpu_core_count                       = var.cpu_core_count
  user_data                            = var.user_data != "" ? base64encode(file(var.user_data)) : ""
  iam_instance_profile                 = join("", aws_iam_instance_profile.default.*.name)
  source_dest_check                    = var.source_dest_check
  ipv6_address_count                   = var.ipv6_address_count
  ipv6_addresses                       = var.ipv6_addresses
  root_block_device {
    volume_size           = var.disk_size
    delete_on_termination = true
  }

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  tags = merge(
    module.labels.tags,
    {

      "Name" = format("%s%s%s", module.labels.id, var.delimiter, (count.index))
    },
    var.instance_tags
  )

  volume_tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s%s%s", module.labels.id, var.delimiter, (count.index))
    }
  )

  lifecycle {
    # Due to several known issues in Terraform AWS provider related to arguments of aws_instance:
    # (eg, https://github.com/terraform-providers/terraform-provider-aws/issues/2036)
    # we have to ignore changes in the following arguments
    ignore_changes = [
      private_ip,
      root_block_device,
      ebs_block_device,
    ]
  }
}

#Module      : EIP
#Description : Provides an Elastic IP resource.
resource "aws_eip" "default" {
  count = var.instance_enabled == true && var.assign_eip_address == true ? var.instance_count : 0

  network_interface = element(aws_instance.default.*.primary_network_interface_id, count.index)
  vpc               = true

  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s%s%s-eip", module.labels.id, var.delimiter, (count.index))
    }
  )
}

#Module      : EBS VOLUME
#Description : Manages a single EBS volume.
resource "aws_ebs_volume" "default" {
  count = var.instance_enabled == true && var.ebs_volume_enabled == true ? var.instance_count : 0

  availability_zone = element(aws_instance.default.*.availability_zone, count.index)
  size              = var.ebs_volume_size
  iops              = local.ebs_iops
  type              = var.ebs_volume_type

  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s%s%s", module.labels.id, var.delimiter, (count.index))
    }
  )
}

#Module      : VOLUME ATTACHMENT
#Description : Provides an AWS EBS Volume Attachment as a top level resource, to attach and detach volumes from AWS Instances.
resource "aws_volume_attachment" "default" {
  count = var.instance_enabled == true && var.ebs_volume_enabled == true ? var.instance_count : 0

  device_name = element(var.ebs_device_name, count.index)
  volume_id   = element(aws_ebs_volume.default.*.id, count.index)
  instance_id = element(aws_instance.default.*.id, count.index)
}

#Module      : IAM INSTANCE PROFILE
#Description : Provides an IAM instance profile.
resource "aws_iam_instance_profile" "default" {
  count = var.instance_enabled == true && var.instance_profile_enabled ? 1 : 0
  name  = format("%s%sinstance-profile", module.labels.id, var.delimiter)
  role  = var.iam_instance_profile
}

#Module      : ROUTE53
#Description : Provides a Route53 record resource.
resource "aws_route53_record" "default" {
  count   = var.instance_enabled == true && var.dns_enabled ? var.instance_count : 0
  zone_id = var.dns_zone_id
  name    = format("%s%s%s", var.hostname, var.delimiter, (count.index))
  type    = var.type
  ttl     = var.ttl
  records = [element(aws_instance.default.*.private_dns, count.index)]
}