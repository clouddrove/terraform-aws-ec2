output "instance_id" {
  value       = module.ec2.*.instance_id
  description = "The instance ID."
}