locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.org_name
  }
}

# GuardDuty
resource "aws_guardduty_detector" "main" {
  count = var.enable_guardduty ? 1 : 0
  enable = true

  tags = local.common_tags
}

# AWS Config
resource "aws_config_configuration_recorder" "main" {
  count = var.enable_config ? 1 : 0
  name  = "config-recorder-${var.environment}"

  role_arn = aws_iam_role.config.0.arn

  recording_group {
    all_supported = true
    include_global_resources = true
  }

  tags = local.common_tags
}

resource "aws_config_delivery_channel" "main" {
  count = var.enable_config ? 1 : 0
  name  = "config-delivery-channel-${var.environment}"

  s3_bucket_name = aws_s3_bucket.config.0.bucket
  s3_key_prefix  = "config"
  sns_topic_arn  = aws_sns_topic.config.0.arn

  depends_on = [aws_config_configuration_recorder.main]
}

resource "aws_s3_bucket" "config" {
  count = var.enable_config ? 1 : 0
  bucket = "config-bucket-${var.environment}-${data.aws_caller_identity.current.account_id}"

  tags = local.common_tags
}

resource "aws_s3_bucket_versioning" "config" {
  count = var.enable_config ? 1 : 0
  bucket = aws_s3_bucket.config.0.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config" {
  count = var.enable_config ? 1 : 0
  bucket = aws_s3_bucket.config.0.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "config" {
  count = var.enable_config ? 1 : 0
  bucket = aws_s3_bucket.config.0.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_sns_topic" "config" {
  count = var.enable_config ? 1 : 0
  name  = "config-topic-${var.environment}"

  tags = local.common_tags
}

resource "aws_sns_topic_policy" "config" {
  count = var.enable_config ? 1 : 0
  arn   = aws_sns_topic.config.0.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.config.0.arn
      }
    ]
  })
}

resource "aws_iam_role" "config" {
  count = var.enable_config ? 1 : 0
  name  = "config-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy" "config" {
  count = var.enable_config ? 1 : 0
  name  = "config-policy-${var.environment}"
  role  = aws_iam_role.config.0.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetBucketAcl"
        ]
        Resource = [
          aws_s3_bucket.config.0.arn,
          "${aws_s3_bucket.config.0.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.config.0.arn
      }
    ]
  })
}

# Data sources
data "aws_caller_identity" "current" {} 