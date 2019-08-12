# Managed By : CloudDrove
# Copyright @ CloudDrove. All Right Reserved.

#Module      : Label
#Description : Terraform module to create consistent naming for multiple names.
module "lables" {
  source      = "git::https://github.com/clouddrove/terraform-lables.git?ref=tags/0.11.0"
  name        = "${var.name}"
  application = "${var.application}"
  environment = "${var.environment}"
}

locals {
  ebs_iops          = "${var.ebs_volume_type == "io1" ? var.ebs_iops : "0"}"
  availability_zone = "${var.availability_zone != "" ? var.availability_zone : data.aws_subnet.default.availability_zone}"
}

data "aws_subnet" "default" {
  id = "${var.subnet}"
}

resource "aws_instance" "main" {
  ami                                  = "${var.ami}"
  ebs_optimized                        = "${var.ebs_optimized}"
  instance_type                        = "${var.instance_type}"
  key_name                             = "${var.key_name}"
  monitoring                           = "${var.monitoring}"
  vpc_security_group_ids               = ["${var.vpc_security_group_ids_list}"]
  subnet_id                            = "${var.subnet}"
  associate_public_ip_address          = "${var.associate_public_ip_address}"
  ebs_block_device                     = "${var.ebs_block_device}"
  ephemeral_block_device               = "${var.ephemeral_block_device}"
  disable_api_termination              = "${var.disable_api_termination}"
  instance_initiated_shutdown_behavior = "${var.instance_initiated_shutdown_behavior}"
  placement_group                      = "${var.placement_group}"
  tenancy                              = "${var.tenancy}"
  user_data                            = "${var.user_data}"

  root_block_device {
    volume_size           = "${var.disk_size}"
    delete_on_termination = true
  }

  tags = "${module.lables.tags}"

  lifecycle {
    # Due to several known issues in Terraform AWS provider related to arguments of aws_instance:
    # (eg, https://github.com/terraform-providers/terraform-provider-aws/issues/2036)
    # we have to ignore changes in the following arguments
    ignore_changes = ["private_ip", "root_block_device", "ebs_block_device"]
  }
}

resource "aws_eip" "default" {
  count             = "${var.associate_public_ip_address == "true" && var.assign_eip_address == "true" ? 1 : 0}"
  network_interface = "${aws_instance.main.primary_network_interface_id}"
  vpc               = "true"
  tags              = "${module.lables.tags}"
}

resource "aws_ebs_volume" "default" {
  count             = "${var.ebs_volume_count}"
  availability_zone = "${local.availability_zone}"
  size              = "${var.ebs_volume_size}"
  iops              = "${local.ebs_iops}"
  type              = "${var.ebs_volume_type}"
  tags              = "${module.lables.tags}"
}

resource "aws_volume_attachment" "default" {
  count       = "${var.ebs_volume_count}"
  device_name = "${element(var.ebs_device_name, count.index)}"
  volume_id   = "${element(aws_ebs_volume.default.*.id, count.index)}"
  instance_id = "${aws_instance.main.id}"
}
