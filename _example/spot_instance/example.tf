####----------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
####----------------------------------------------------------------------------------
provider "aws" {
  region = "eu-west-1"
}

####----------------------------------------------------------------------------------
## A VPC is a virtual network that closely resembles a traditional network that you'd operate in your own data center.
####----------------------------------------------------------------------------------
module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "1.3.1"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]

  cidr_block = "172.16.0.0/16"
}

####----------------------------------------------------------------------------------
## A subnet is a range of IP addresses in your VPC.
####----------------------------------------------------------------------------------
module "private-subnets" {
  source  = "clouddrove/subnet/aws"
  version = "1.3.0"

  name        = "subnet"
  environment = "test"
  label_order = ["name", "environment"]

  availability_zones              = ["eu-west-1b", "eu-west-1c"]
  vpc_id                          = module.vpc.vpc_id
  type                            = "private"
  cidr_block                      = module.vpc.vpc_cidr_block
  ipv6_cidr_block                 = module.vpc.ipv6_cidr_block
  assign_ipv6_address_on_creation = false
  enable_vpc_endpoint             = false
}
####----------------------------------------------------------------------------------
## Terraform module to create IAm role resource on AWS.
####----------------------------------------------------------------------------------
module "iam-role" {
  source  = "clouddrove/iam-role/aws"
  version = "1.3.0"

  name               = "iam-role"
  environment        = "test"
  label_order        = ["name", "environment"]
  assume_role_policy = data.aws_iam_policy_document.default.json

  policy_enabled = true
  policy         = data.aws_iam_policy_document.iam-policy.json
}

data "aws_iam_policy_document" "default" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "iam-policy" {
  statement {
    actions = [
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
    "ssmmessages:OpenDataChannel"]
    effect    = "Allow"
    resources = ["*"]
  }
}

####----------------------------------------------------------------------------------
## Terraform module to create spot instance module on AWS.
####----------------------------------------------------------------------------------
module "spot-ec2" {
  source      = "./../../"
  name        = "ec2"
  environment = "test"
  label_order = ["name", "environment"]

  ####----------------------------------------------------------------------------------
  ## Below A security group controls the traffic that is allowed to reach and leave the resources that it is associated with.
  ####----------------------------------------------------------------------------------
  vpc_id            = module.vpc.vpc_id
  ssh_allowed_ip    = ["0.0.0.0/0"]
  ssh_allowed_ports = [22]

  #Keypair
  public_key = "h5/gxz7sbSSseLd+ldHEOM3+lajUSGqWk3Bw/NgygEf1Kgw7gyK3jsTVVcokhK3TDuR3pi4u2QDR2tvLXddPKd37a2S7rjeqecw+XRW9559zKaR7RJJfjO1u1Onc2tgA3y0btdju2bcYBtFkRVOLwpog8CvslYEDV1Vf9HNeh9A3yOS6Pkjq6gDMrsUVF89ps3zuLmdVBIlCOnJDkwHK71lKihGKdkeXEtAj0aOQzAJsIpDFXz7vob9OiA/fb2T3t4R1EwEsPEnYVczKMsqUyqa+EE36bItcZHQyCPVN7+bRJyJpPcrfrsAa4yMtiHUUiecPdL/6HYwGHxA5rUX3uD2UBm6sbGBHxQOTHBwKHaGvKLk4c5gHXaEl8yyYL0wVkL00KYx3GCh1LvRdQL8fvzImBCNg"

  # Spot-instance
  spot_price                          = "0.3"
  spot_wait_for_fulfillment           = true
  spot_type                           = "persistent"
  spot_instance_interruption_behavior = "terminate"
  spot_instance_enabled               = true
  spot_instance_count                 = 1
  spot_ami                            = "ami-08d658f84a6d84a80"
  instance_type                       = "c4.xlarge"

  #Networking
  subnet_ids = tolist(module.private-subnets.public_subnet_id)

  #IAM
  iam_instance_profile = module.iam-role.name

  #Root Volume
  root_block_device = [
    {
      volume_type           = "gp2"
      volume_size           = 15
      delete_on_termination = true
    }
  ]

  #EBS Volume
  ebs_volume_enabled = true
  ebs_volume_type    = "gp2"
  ebs_volume_size    = 30

  #Tags
  spot_instance_tags = { "snapshot" = true }

}