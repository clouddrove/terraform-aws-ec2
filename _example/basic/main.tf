####----------------------------------------------------------------------------------
## Terraform module to create instance module on AWS.
####----------------------------------------------------------------------------------
module "ec2" {
  source      = "./../../"
  name        = "ec2"
  environment = "test"

  ####----------------------------------------------------------------------------------
  ## Below A security group controls the traffic that is allowed to reach and leave the resources that it is associated with.
  ####----------------------------------------------------------------------------------
  #tfsec:aws-ec2-no-public-ingress-sgr
  vpc_id            = "vpc-xxxxxxxxx"
  ssh_allowed_ip    = ["0.0.0.0/0"]
  ssh_allowed_ports = [22]

  #instance
  instance_count = 1
  ami            = "ami-08d658f84a6d84a80"
  instance_type  = "c4.xlarge"

  #Networking
  subnet_ids = ["subnet-xxxxxxxx"]

  #Keypair
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCm63Yf1+E6Fkts7LcAdOalvdUrZE0oA1A6pJUkx9c/V8ZFuclg7uNdnXV98iHWlA6tcvV69HsdBJZU3w66+6rxGgM0dbwSalRz60IGM40HwRTYZNn0e/1xwL3O0tvsIiSdapLDjPXIm4zZGQL7KXT98f6LJzDfDBF67ZEAVoeOxIl/a1k+DOTRuFtg7dtvPhJQpDCh685EtiC/+HH4vpHcw3LcNfP2WaifQpCG4Pxgj6KWf1bGVJhhpN26lbJYfN4n+GZJYDKDS+Tc4eF4aC1s1JnOtKC2z1bb+FI7Y4ZdYfIsdf0P1Fo751JLp7fjTqckBgxYd+iXAhKO6dPjbVp3L56pxTJbbSgi5Cw29+Ef8AcK9WOGCgbnma7XmCpFF0NxSSLim74p2y+oyjt1UmX9UvOKnb1MXlGW4JYo4qQV4M5TL64JcYa5sSRDvMhtpC83YVpKyRb3bTNZySsgkDuxFCNsJ0c9UAWTbqzSmhpPsM9ItfBSxhq0oiogGpvNgXM="

  #IAM
  iam_instance_profile = "iam-profile-xxxxxxxxx"

  #Root Volume
  root_block_device = [
    {
      volume_type           = "gp2"
      volume_size           = 15
      delete_on_termination = true
    }
  ]
  #Tags
  instance_tags = { "snapshot" = true }

}