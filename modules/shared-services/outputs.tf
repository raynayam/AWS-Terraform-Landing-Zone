output "logging_bucket_name" {
  description = "The name of the central logging bucket"
  value       = aws_s3_bucket.logging.bucket
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.main.name
}

output "secrets_manager_arn" {
  description = "The ARN of the Secrets Manager"
  value       = aws_secretsmanager_secret.main.arn
}

output "kms_key_arn" {
  description = "The ARN of the KMS key for Secrets Manager"
  value       = aws_kms_key.secrets.arn
}

output "cloudwatch_alarm_names" {
  description = "List of CloudWatch alarm names"
  value = [
    aws_cloudwatch_metric_alarm.high_cpu.alarm_name,
    aws_cloudwatch_metric_alarm.high_memory.alarm_name
  ]
} 