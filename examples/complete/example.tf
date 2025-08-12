####----------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
####----------------------------------------------------------------------------------
provider "aws" {
  region = local.region
}

locals {
  environment = "test-app"
  label_order = ["name", "environment"]
  region      = "us-east-1"
}

####----------------------------------------------------------------------------------
## A VPC is a virtual network that closely resembles a traditional network that you'd operate in your own data center.
####----------------------------------------------------------------------------------
module "vpc" {
  source      = "clouddrove/vpc/aws"
  version     = "2.0.0"
  name        = "vpc"
  environment = local.environment
  label_order = local.label_order
  cidr_block  = "172.16.0.0/16"
}

####----------------------------------------------------------------------------------
## A subnet is a range of IP addresses in your VPC.
####----------------------------------------------------------------------------------
module "public_subnets" {
  source             = "clouddrove/subnet/aws"
  version            = "2.0.1"
  name               = "public-subnet"
  environment        = local.environment
  label_order        = local.label_order
  availability_zones = ["${local.region}b", "${local.region}c"]
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block
  type               = "public"
  igw_id             = module.vpc.igw_id
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
}

module "iam-role" {
  source             = "clouddrove/iam-role/aws"
  version            = "1.3.2"
  name               = "iam-role"
  environment        = local.environment
  label_order        = local.label_order
  assume_role_policy = data.aws_iam_policy_document.default.json
  policy_enabled     = true
  policy             = data.aws_iam_policy_document.iam-policy.json
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

##----------------------------------------------------------------------------------
## Terraform module to create ec2 instance module on AWS.
##----------------------------------------------------------------------------------
module "ec2" {
  source      = "./../../"
  name        = "ec2"
  environment = local.environment

  ##----------------------------------------------------------------------------------
  ## Below A security group controls the traffic that is allowed to reach and leave the resources that it is associated with.
  ##----------------------------------------------------------------------------------
  #tfsec:aws-ec2-no-public-ingress-sgr
  vpc_id = module.vpc.vpc_id

  instance_count = 1
  instance_configuration = {
    ami = {
      type         = "ubuntu" # -- valid values are - al1, al2, al2023, ubuntu
      architecture = "x86_64" # -- valid values are - arm64 or x86_64
      version      = "22.04"  # Only required if type = ubuntu. Defaults to 22.04, valid values are - 20.04, 22.04, 23.04
      region       = local.region
    }
    instance_type = "t3.small"
    root_block_device = [
      {
        volume_type           = "gp3"
        volume_size           = 15
        delete_on_termination = true
      }
    ]
    #Mount EBS With User Data
    user_data = file("user-data.sh")
  }

  #Keypair
  public_key = ""

  #Networking
  subnet_ids = tolist(module.public_subnets.public_subnet_id)

  #IAM
  iam_instance_profile = module.iam-role.name

  #EBS Volume
  ebs_volume_enabled = true
  ebs_volume_type    = "gp3"
  ebs_volume_size    = 30

  #Tags
  instance_tags = { "snapshot" = true }
}