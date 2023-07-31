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
  version = "2.0.0"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]

  cidr_block = "172.16.0.0/16"
}

####----------------------------------------------------------------------------------
## A subnet is a range of IP addresses in your VPC.
####----------------------------------------------------------------------------------
module "public_subnets" {
  source  = "clouddrove/subnet/aws"
  version = "2.0.0"

  name        = "public-subnet"
  environment = "test"
  label_order = ["name", "environment"]

  availability_zones = ["eu-west-1b", "eu-west-1c"]
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block
  type               = "public"
  igw_id             = module.vpc.igw_id
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
}

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
## Terraform module to create instance module on AWS.
####----------------------------------------------------------------------------------
module "ec2" {
  source      = "./../../"
  name        = "ec2"
  environment = "test"
  label_order = ["name", "environment"]

  ####----------------------------------------------------------------------------------
  ## Below A security group controls the traffic that is allowed to reach and leave the resources that it is associated with.
  ####----------------------------------------------------------------------------------
  #tfsec:aws-ec2-no-public-ingress-sgr
  vpc_id            = module.vpc.vpc_id
  ssh_allowed_ip    = ["0.0.0.0/0"]
  ssh_allowed_ports = [22]

  #instance
  instance_count = 1
  ami            = "ami-08d658f84a6d84a80"
  instance_type  = "c4.xlarge"

  #Networking
  subnet_ids = tolist(module.public_subnets.public_subnet_id)

  #Keypair
  public_key = "ssh-rsa ArJh5/gxz7sbSSseLd+ldHEOM3+lajUSGqWk3Bw/NgygEf1Kgw7gyK3jsTVVcokhK3TDuR3pi4u2QDR2tvLXddPKd37a2S7rjeqecw+XRW9559zKaR7RJJfjO1u1Onc2tgA3y0btdju2bcYBtFkRVOLwpog8CvslYEDV1Vf9HNeh9A3yOS6Pkjq6gDMrsUVF89ps3zuLmdVBIlCOnJDkwHK71lKihGKdkeXEtAj0aOQzAJsIpDFXz7vob9OiA/fb2T3t4R1EwEsPEnYVczKMsqUyqa+EE36bItcZHQyCPVN7+bRJyJpPcrfrsAa4yMtiHUUiecPdL/6HYwGHxxl2UQR5NE4NR35NI86Q+q1kNOc5VctxxQOTHBwKHaGvKLk4c5gHXaEl8yyYL0wVkL00KYx3GCh1LvRdQ"

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
  ebs_volume_enabled = false
  ebs_volume_type    = "gp2"
  ebs_volume_size    = 30

  #Tags
  instance_tags = { "snapshot" = true }

}