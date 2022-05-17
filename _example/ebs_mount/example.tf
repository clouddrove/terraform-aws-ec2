provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "0.15.0"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]

  cidr_block = "172.16.0.0/16"
}

module "public_subnets" {
  source  = "clouddrove/subnet/aws"
  version = "0.15.0"

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
  version     = "0.15.0"
  name        = "http-https"
  environment = "test"
  label_order = ["name", "environment"]

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = ["0.0.0.0/0"]
  allowed_ports = [80, 443]
}

module "ssh" {
  source      = "clouddrove/security-group/aws"
  version     = "0.15.0"
  name        = "ssh"
  environment = "test"
  label_order = ["name", "environment"]

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block, "0.0.0.0/0"]
  allowed_ports = [22]
}

module "keypair" {
  source  = "clouddrove/keypair/aws"
  version = "0.15.0"

  public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMw9taDn3K84VTc8hA4Sm+tCmh6pg53eSeIvHpJoH5VN917JHNcDf/C8rA0bl6RrRpmDXieA5313Br3UP5qXZSebyRA+WcXtxB8zk9xntliwXU+GpX4WCMcCPLgDkUbbmKInESoH2DFnqgfxyWQaOYZJ2W7/6Aa17qTtrT04FdQel2jdNGjp7BwjHFJxAiSUbDuJPFjZUoEATpryUyT4opAQh7lo/ZwSxrH6wPSGAC0npp/hiJ8/PN2zpFbVJBlHXX96bCGfYQUC013xN54z4HmElGTCtC45SGQ766lmGiIRfxUh/EprjrCQ/u0yOidz1l/eed/CruKss2Vzgd9CnA4tB/3UhsAnEZoTz2Qb4NnWIdHZC8kKIlAumQxLEb/yukofdO0JEGi07LsgwRx1gDcESFzcfnHHNXMybrPU3YrOPI9x22QHt5ufmeZTw3zqIsm7plxhUlhwaIEOzKLjZC9Y9L6FAulz0uMKsOdDqXKAkrujI6/cgxHqUZ8oq8t8E= prashant@prashant"
  key_name        = "devops"
  environment     = "test"
  label_order     = ["name", "environment"]
  enable_key_pair = true
}

module "iam-role" {
  source  = "clouddrove/iam-role/aws"
  version = "0.15.0"

  name               = "iam-role"
  environment        = "test"
  label_order        = ["name", "environment"]
  assume_role_policy = data.aws_iam_policy_document.default.json

  policy_enabled = true
  policy         = data.aws_iam_policy_document.iam-policy.json
}

module "kms_key" {
  source                  = "clouddrove/kms/aws"
  version                 = "0.15.0"
  name                    = "kms"
  environment             = "test"
  label_order             = ["environment", "name"]
  enabled                 = true
  description             = "KMS key for ec2"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/ec2"
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

  #Instance
  instance_enabled = true
  instance_count   = 2
  ami              = "ami-08d658f84a6d84a80"
  instance_type    = "t2.nano"
  monitoring       = false
  tenancy          = "default"

  #Keypair
  key_name = module.keypair.name

  #Networking
  vpc_security_group_ids_list = [module.ssh.security_group_ids, module.http-https.security_group_ids]
  subnet_ids                  = tolist(module.public_subnets.public_subnet_id)
  assign_eip_address          = true
  associate_public_ip_address = true

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
  ebs_volume_enabled = true
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

  #Mount EBS With User Data
  user_data = file("user-data.sh")
}
