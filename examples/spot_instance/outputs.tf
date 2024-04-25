output "spot_instance_id" {
  value       = module.spot-ec2[*].spot_instance_id
  description = "The instance ID."
}

output "spot_tags" {
  value       = module.spot-ec2[*].tags
  description = "The instance tags."
}

output "spot_bid_status" {
  value       = module.spot-ec2.spot_bid_status
  description = "The current bid status of the Spot Instance Request"
}