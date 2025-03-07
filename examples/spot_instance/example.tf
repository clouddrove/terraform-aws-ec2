####----------------------------------------------------------------------------------
## Terraform module to create spot instance module on AWS.
####----------------------------------------------------------------------------------
module "spot-ec2" {
  source      = "./../../"
  name        = "ec2"
  environment = "test"

  ####----------------------------------------------------------------------------------
  ## Below A security group controls the traffic that is allowed to reach and leave the resources that it is associated with.
  ####----------------------------------------------------------------------------------
  vpc_id            = "vpc-xxxxxxxx"
  ssh_allowed_ip    = ["0.0.0.0/0"]
  ssh_allowed_ports = [22]

  #Keypair
  public_key = ""

  # Spot-instance
  spot_configuration = {
    spot_price                     = "0.3"
    wait_for_fulfillment           = true
    spot_type                      = "persistent"
    instance_interruption_behavior = "terminate"
    spot_instance_enabled          = true
    spot_instance_count            = 1
    instance_type                  = "t4g.small"

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