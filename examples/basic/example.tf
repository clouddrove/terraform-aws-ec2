locals {
  name        = "clouddrove"
  region      = "us-east-1"
  environment = "test"
  label_order = ["environment", "name"]
}

provider "aws" {
  region = local.region
}

## Minimal EC2 example.
## provide subnet/VPC IDs from your network module or existing VPC.
module "ec2" {
  source = "../../"

  name        = "${local.name}-ec2"
  environment = local.environment
  label_order = local.label_order
  vpc_id      = "vpc-xxxxxxxx"      # Replace with your VPC ID.
  subnet_ids  = ["subnet-xxxxxxxx"] # Replace with a subnet in the same VPC.

  instance_count = 1
  instance_configuration = {
    ami = {
      type         = "al2023"
      architecture = "x86_64"
      region       = local.region # AWS provider region must match this region.
    }
    instance_type = "t3.micro"
  }

  # No inbound rules are added by default. If SSH is required, restrict
  # ssh_allowed_ip to a trusted CIDR instead of 0.0.0.0/0.
  enable_key_pair    = false
  assign_eip_address = false
}
