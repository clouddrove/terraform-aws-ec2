output "instance_id" {
  value       = module.ec2.*.instance_id
  description = "The instance ID."
}

output "tags" {
  value       = module.ec2.tags
  description = "The instance tags."
}
