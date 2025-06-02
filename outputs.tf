output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "data_subnet_ids" {
  description = "List of data subnet IDs"
  value       = module.network.data_subnet_ids
}

output "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
  value       = module.network.transit_gateway_id
}

output "logging_bucket_name" {
  description = "The name of the central logging bucket"
  value       = module.shared_services.logging_bucket_name
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch Log Group"
  value       = module.shared_services.cloudwatch_log_group_name
}

output "secrets_manager_arn" {
  description = "The ARN of the Secrets Manager"
  value       = module.shared_services.secrets_manager_arn
}

output "guardduty_detector_id" {
  description = "The ID of the GuardDuty detector"
  value       = module.security.guardduty_detector_id
}

output "config_recorder_name" {
  description = "The name of the AWS Config recorder"
  value       = module.security.config_recorder_name
}

output "break_glass_role_arn" {
  description = "The ARN of the break glass role"
  value       = module.iam.break_glass_role_arn
}

output "admin_role_arn" {
  description = "The ARN of the admin role"
  value       = module.iam.admin_role_arn
}

output "readonly_role_arn" {
  description = "The ARN of the read-only role"
  value       = module.iam.readonly_role_arn
} 