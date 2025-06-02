output "break_glass_role_arn" {
  description = "The ARN of the break glass role"
  value       = aws_iam_role.break_glass.arn
}

output "admin_role_arn" {
  description = "The ARN of the admin role"
  value       = aws_iam_role.admin.arn
}

output "readonly_role_arn" {
  description = "The ARN of the read-only role"
  value       = aws_iam_role.readonly.arn
}

output "sso_permission_set_arn" {
  description = "The ARN of the SSO permission set (if SSO is configured)"
  value       = var.sso_provider != null ? aws_ssoadmin_permission_set.break_glass[0].arn : null
} 