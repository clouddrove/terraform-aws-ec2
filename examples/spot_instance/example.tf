####----------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
####----------------------------------------------------------------------------------
provider "aws" {
  region = local.region
}

locals {
  name        = "clouddrove"
  region      = "us-east-1"
  environment = "test"
  label_order = ["environment", "name"]
}

####----------------------------------------------------------------------------------
## Terraform module to create spot instance module on AWS.
####----------------------------------------------------------------------------------
module "spot-ec2" {
  source      = "../.."
  name        = "${local.name}-ec2"
  environment = local.environment
  label_order = local.label_order

  ####----------------------------------------------------------------------------------
  ## Below A security group controls the traffic that is allowed to reach and leave the resources that it is associated with.
  ####----------------------------------------------------------------------------------
  vpc_id = "vpc-xxxxxxxx"
  # This example does not need SSH access or an SSH key pair.
  enable_key_pair = false

  instance_configuration = {
    instance_type = "t4g.small"
    ami = {
      type         = "ubuntu"
      architecture = "x86_64"
      version      = "22.04"
      region       = local.region
    }
    #Root Volume
    root_block_device = [
      {
        volume_type           = "gp3"
        volume_size           = 15
        delete_on_termination = true
      }
    ]
  }

  # Spot-instance
  spot_configuration = {
    spot_price                     = "0.3"
    wait_for_fulfillment           = true
    spot_type                      = "persistent"
    instance_interruption_behavior = "terminate"
  }
  spot_instance_enabled = true
  spot_instance_count   = 1

  # Launch configuration is shared with regular EC2 instances. Keep it outside
  # spot_configuration, which only controls the Spot request itself.
  instance_configuration = {
    ami = {
      type         = "al2023"
      architecture = "arm64"
      region       = local.region
    }
    instance_type = "t4g.small"
    root_block_device = [
      {
        volume_type           = "gp3"
        volume_size           = 15
        delete_on_termination = true
      }
    ]
  }

  #Networking
  subnet_ids = ["subnet-xxxxxxxx"]

  #IAM
  iam_instance_profile = "iam-profile-xxxxxxxxx"

  #Root Volume

  #EBS Volume
  ebs_volume_enabled = true
  ebs_volume_type    = "gp3"
  ebs_volume_size    = 30

  #Tags
  spot_instance_tags = { "snapshot" = true }

}
