locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.org_name
  }
}

# Break Glass Role
resource "aws_iam_role" "break_glass" {
  name = "break-glass-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.break_glass_users
        }
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent": "true"
          }
        }
      }
    ]
  })

  tags = local.common_tags
}

# Admin Role
resource "aws_iam_role" "admin" {
  name = "admin-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.admin_users
        }
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent": "true"
          }
        }
      }
    ]
  })

  tags = local.common_tags
}

# Read-Only Role
resource "aws_iam_role" "readonly" {
  name = "readonly-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.readonly_users
        }
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent": "true"
          }
        }
      }
    ]
  })

  tags = local.common_tags
}

# Attach policies to roles
resource "aws_iam_role_policy_attachment" "break_glass_admin" {
  role       = aws_iam_role.break_glass.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "admin_power_user" {
  role       = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "readonly_viewer" {
  role       = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ViewOnlyAccess"
}

# AWS SSO Configuration (if provided)
resource "aws_ssoadmin_account_assignment" "break_glass" {
  count = var.sso_provider != null ? 1 : 0

  instance_arn       = var.sso_provider.metadata
  permission_set_arn = aws_ssoadmin_permission_set.break_glass[0].arn
  principal_id       = var.break_glass_users[0]
  target_id          = data.aws_caller_identity.current.account_id
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_permission_set" "break_glass" {
  count = var.sso_provider != null ? 1 : 0

  name             = "BreakGlass-${var.environment}"
  instance_arn     = var.sso_provider.metadata
  session_duration = "PT8H"
}

data "aws_caller_identity" "current" {} 