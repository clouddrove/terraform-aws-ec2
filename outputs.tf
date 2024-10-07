#Module      : EC2
#Description : Terraform module to create an EC2 resource on AWS with Elastic IP Addresses #              and Elastic Block Store.
output "instance_id" {
  value       = aws_instance.default[*].id
  description = "The instance ID."
}

output "arn" {
  value       = aws_instance.default[*].arn
  description = "The ARN of the instance."
}

output "az" {
  value       = aws_instance.default[*].availability_zone
  description = "The availability zone of the instance."
}

output "public_ip" {
  value       = concat(aws_eip.default[*].public_ip, aws_instance.default[*].public_ip, [""])
  description = "Public IP of instance (or EIP)."

}

output "private_ip" {
  value       = aws_instance.default[*].private_ip
  description = "Private IP of instance."
}

output "placement_group" {
  value       = join("", aws_instance.default[*].placement_group)
  description = "The placement group of the instance."
}

output "key_name" {
  value       = join("", aws_instance.default[*].key_name)
  description = "The key name of the instance."
}

output "ipv6_addresses" {
  value       = aws_instance.default[*].ipv6_addresses
  sensitive   = true
  description = "A list of assigned IPv6 addresses."
}

output "vpc_security_group_ids" {
  value       = aws_instance.default[*].vpc_security_group_ids
  sensitive   = true
  description = "The associated security groups in non-default VPC."
}

output "subnet_id" {
  value       = aws_instance.default[*].subnet_id
  sensitive   = true
  description = "The EC2 subnet ID."
}

output "instance_count" {
  value       = var.instance_count
  description = "The count of instances."
}
output "name" {
  value       = join("", aws_key_pair.default[*].key_name)
  description = "Name of SSH key."
}

output "spot_instance_id" {
  value       = aws_spot_instance_request.default[*].spot_instance_id
  description = "The instance ID."
}

output "spot_bid_status" {
  description = "The current bid status of the Spot Instance Request"
  value       = join("", aws_spot_instance_request.default[*].spot_bid_status)
}
output "tags" {
  value       = module.labels.tags
  description = "The instance ID."
}
