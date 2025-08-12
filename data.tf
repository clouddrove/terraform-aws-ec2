######################################
# LOCALS
######################################
locals {
  # Map for Amazon Linux AMI patterns
  ami_name_map = {
    al1    = "amzn-ami-*"
    al2    = "amzn2-ami-hvm-*"
    al2023 = "al2023-ami-*"
  }

  # Map for AMI owner IDs
  ami_owner_map = {
    al1    = "591542846629" # Amazon
    al2    = "137112412989" # Amazon
    al2023 = "137112412989" # Amazon
  }
}

######################################
# Amazon (ARM, AMD)
######################################
data "aws_ami" "amazon" {
  count       = var.instance_configuration.ami.type != "ubuntu" ? 1 : 0
  most_recent = true
  owners      = [local.ami_owner_map[var.instance_configuration.ami.type]]

  filter {
    name   = "name"
    values = [local.ami_name_map[var.instance_configuration.ami.type]]
  }

  filter {
    name   = "architecture"
    values = [var.instance_configuration.ami.architecture]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

######################################
# Ubuntu (ARM, AMD)
######################################
data "aws_ami" "ubuntu" {
  count       = var.instance_configuration.ami.type == "ubuntu" ? 1 : 0
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name = "name"
    values = [
      "${var.instance_configuration.ami.type}/images/*${var.instance_configuration.ami.version == null ? "22.04" : var.instance_configuration.ami.version}*"
    ]
  }

  filter {
    name   = "architecture"
    values = [var.instance_configuration.ami.architecture]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
