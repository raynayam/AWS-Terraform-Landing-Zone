output "guardduty_detector_id" {
  description = "The ID of the GuardDuty detector"
  value       = var.enable_guardduty ? aws_guardduty_detector.main[0].id : null
}

output "config_recorder_name" {
  description = "The name of the AWS Config recorder"
  value       = var.enable_config ? aws_config_configuration_recorder.main[0].name : null
}

output "config_bucket_name" {
  description = "The name of the S3 bucket for AWS Config"
  value       = var.enable_config ? aws_s3_bucket.config[0].bucket : null
}

output "config_sns_topic_arn" {
  description = "The ARN of the SNS topic for AWS Config notifications"
  value       = var.enable_config ? aws_sns_topic.config[0].arn : null
} 