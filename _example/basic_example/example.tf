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

module "keypair" {
  source  = "clouddrove/keypair/aws"
  version = "0.15.0"

  public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAD9QDxGN5VCED4YkSYTdhzlBsztM0U/5sw7eCjbjO5d20kqCTdvcW+XJzKv8ofRWMOUnYayAkKDQbyU1PBz0uIwOaBydx22Iu/h1EGxmXZb3gU2NlGb9YcCnHX48ZQwsNcmdSbvWQpbVzbBHk2mdiZd8eOEtlMpuhiQVKRV4eb3fzpHWHcbumfF5Y2X7V7bY7/J0J+LbhnOX3CmnB5541kiMn0WiXt0yQNZ0ViII8ygq+mRiGHZULA0FysjNrK3wqqawb91/aamIoacfXxnS0vLgt3CRHIKneiIyei6WtTMw57QPPilctw93OIE3WvYOPcuWhkELrVSRpiRR9/saHkXGjQHm0pueiAODiqSoM3u3MGJb2qX5o/CFtFlPZWLqVLlk1q+zeb/yWOWV42zsQ+X+Glh7ynqnYfIzyQT7Bs0xBv95RBQabsjhYfi9OgImLyN6OZtpMev2T1l90DW2DjZp1iqAXvXQuFLJu0ygNpMlK4Ot6ZhahzgBCPy6oVvaPIHzWpRGt7iBiSZB1QYXnlYQ0VcN6LHZk2oq1Jjjd0yDMzO71onIcd8P7qCwlUhis7Yeq5B+3nzZce9G3lSptwHnKG3CDByemUdXp4WKhYpsixQHImgrZjXvLJVyMDP5RSJp57BxxAw1CbjmWAbuAAR6BpOceLxYwsEscmYPyPISZMFLhge56TX4mqTSSX+fBtBEPC4hbqMdZAW9boHqoBChqffOdnUe3NFT0BuxqwsUbqBCx/AWBop5ASSds4rN6cdROml+UvlSrrAp3htSaBafrE+9x1sLG7P9R97xZGFTTlfZoJcXHZ/405EdsOcU8k2WZOJOrrf3R4995AQsotSB6vqia/rFaXtzDPGLaJqUkluzH7RPRYYKG2PqVJuXkMOLA0i/JNTGwNO14UDK+qBnWiwQeZzfJeHqJXy1eNMMZJVMDLn/qEUezhJjuCOIF1kYJclHmCZtd07y4R4B3/vOYdknuwughecV3iBxF+pAzy8MckPaZVaR+dHoyNoD4ua9eIVDF71aXnqBHd2B3n1o4+3Jd2axyOV1uFP8jhpMeVaesTA+K+/oW8Bq+52c+1rpdySU5aozOJEncyolC+DLEgRYGuAaiXNIR/IZFsDJHD+GByMtopPzu4kvGbyRZp/I0u43MMDlcjCTZJLhVntrI1spgTMElFcFepS5piL062xwY8S/gFAB3TJH4Rx+fcOkYsRh9wb4gJ0Wy+d7sHVu2qLYgBCeeSYBR4DLRTv57gcgE9hdaBo7b2AXPevPV3LbUGuqDkF+pEHOdMPCTgW4lOFxfl6vpitP+o8kErNdt8T8ftwJccHv5x6NLI82lUMfdo8qIV devops"
  key_name        = "devops"
  environment     = "test"
  label_order     = ["name", "environment"]
  enable_key_pair = true
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
  alias                   = "alias/ec2-instance"
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
  instance_count   = 2
  ami              = "ami-08d658f84a6d84a80"
  instance_type    = "t2.nano"
  monitoring       = false
  tenancy          = "default"

  #Networking
  vpc_security_group_ids_list = [module.ssh.security_group_ids, module.http-https.security_group_ids]
  subnet_ids                  = tolist(module.public_subnets.public_subnet_id)
  assign_eip_address          = true
  associate_public_ip_address = true

  #Keypair
  key_name = module.keypair.name

  #IAM
  instance_profile_enabled = false
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
