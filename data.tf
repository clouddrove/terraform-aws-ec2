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

  ami_type         = try(var.instance_configuration.ami.type, "al2023")
  ami_architecture = try(var.instance_configuration.ami.architecture, "arm64")
  ami_version      = try(var.instance_configuration.ami.version, null)
  use_ami_lookup   = var.instance_configuration.ami_id == ""
}

######################################
# Amazon (ARM, AMD)
######################################
data "aws_ami" "amazon" {
  count       = local.use_ami_lookup && local.ami_type != "ubuntu" ? 1 : 0
  most_recent = true
  owners      = [lookup(local.ami_owner_map, local.ami_type, local.ami_owner_map.al2023)]

  filter {
    name   = "name"
    values = [lookup(local.ami_name_map, local.ami_type, local.ami_name_map.al2023)]
  }

  filter {
    name   = "architecture"
    values = [local.ami_architecture]
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
  count       = local.use_ami_lookup && local.ami_type == "ubuntu" ? 1 : 0
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name = "name"
    values = [
      "ubuntu/images/*${coalesce(local.ami_version, "22.04")}*"
    ]
  }

  filter {
    name   = "architecture"
    values = [local.ami_architecture]
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
