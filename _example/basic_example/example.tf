provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "0.15.1"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]

  cidr_block = "172.16.0.0/16"
}

module "public_subnets" {
  source  = "clouddrove/subnet/aws"
  version = "0.15.3"

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

module "http-https" {
  source      = "clouddrove/security-group/aws"
  version     = "1.0.1"
  name        = "http-https"
  environment = "test"
  label_order = ["name", "environment"]

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = ["0.0.0.0/0"]
  allowed_ports = [80, 443]
}

module "keypair" {
  source  = "clouddrove/keypair/aws"
  version = "1.0.1"

  public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDePaKOIIBqWYSGXfs0KgwaIJayIRtFVTgvJthcoX0geFCnDqmYcTw0/Cl6ooX2UtT2yAQ3BLdSIHKXKxxxBU4jxQUvKHGEIS6/7CC6DhNsaE7HolqC7lgrHglaHiGyin/l5NtLjGxgZ+v5qEJ1k2ZRcCpIikmK9ny6VYEF9pvjk7qe1rtSpVIexrn59ncaA3anQnfeqogWvyOTrK6uTOw9i+r10vwRamtwtLVCF1cFEaYLB6EvZ1Oh7PeeaqAivEwJVxKPdj/WgCju7cdfJ/H/WBKbs1/bonSNsapVl2Co/fwoKN8SdLHPwTw+Sqkkdz4GIho0tiCY0jXflVKHX96HA/ccV2sb6lQDds+sP+NrpPravJv0nXw3rhIG06joouZ28niQzQ8Cyizs+osxi+M2FM5CtriAMH7vcxXozVN59fpd66YEi0Iy9+LCyTxSO/QWdmQla4Fr/cEVqRuRbCrHzRfDlt+8Ht33ia2nVC0PclUCdMb13lACm4Ku7FVc4Xc= ubuntu@DESKTOP-9F28BVU"
  key_name        = "devops"
  environment     = "test"
  label_order     = ["name", "environment"]
  enable_key_pair = true
}


module "ssh" {
  source      = "clouddrove/security-group/aws"
  version     = "1.0.1"
  name        = "ssh"
  environment = "test"
  label_order = ["name", "environment"]

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block, "0.0.0.0/0"]
  allowed_ports = [22]
}

module "iam-role" {
  source  = "clouddrove/iam-role/aws"
  version = "1.0.1"

  name               = "iam-role"
  environment        = "test"
  label_order        = ["name", "environment"]
  assume_role_policy = data.aws_iam_policy_document.default.json

  policy_enabled = true
  policy         = data.aws_iam_policy_document.iam-policy.json
}

module "kms_key" {
  source                  = "clouddrove/kms/aws"
  version                 = "1.0.1"
  name                    = "kms"
  environment             = "test"
  label_order             = ["environment", "name"]
  enabled                 = true
  description             = "KMS key for ec2"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/ec3"
  policy                  = data.aws_iam_policy_document.kms.json
}


data "aws_iam_policy_document" "kms" {
  version = "2012-10-17"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

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

module "ec2" {
  source      = "./../../"
  name        = "ec2"
  environment = "test"
  label_order = ["name", "environment"]

  #instance
  instance_enabled = true
  instance_count   = 1
  ami              = "ami-08d658f84a6d84a80"
  instance_type    = "t2.nano"
  monitoring       = false
  tenancy          = "default"
  hibernation      = false

  #Networking
  vpc_security_group_ids_list = [module.ssh.security_group_ids, module.http-https.security_group_ids]
  subnet_ids                  = tolist(module.public_subnets.public_subnet_id)
  assign_eip_address          = true
  associate_public_ip_address = true

  #Keypair
  key_name = module.keypair.name

  #IAM
  instance_profile_enabled = true
  iam_instance_profile     = module.iam-role.name

  #Root Volume
  root_block_device = [
    {
      volume_type           = "gp2"
      volume_size           = 15
      delete_on_termination = true
      kms_key_id            = module.kms_key.key_arn
    }
  ]

  #EBS Volume
  ebs_optimized      = false
  ebs_volume_enabled = false
  ebs_volume_type    = "gp2"
  ebs_volume_size    = 30

  #DNS
  dns_enabled = false
  dns_zone_id = "Z1XJD7SSBKXLC1"
  hostname    = "ec2"

  #Tags
  instance_tags = { "snapshot" = true }

  # Metadata
  metadata_http_tokens_required        = "optional"
  metadata_http_endpoint_enabled       = "enabled"
  metadata_http_put_response_hop_limit = 2

}
