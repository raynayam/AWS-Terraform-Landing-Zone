variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "org_name" {
  description = "Organization name for resource tagging"
  type        = string
}

variable "enable_guardduty" {
  description = "Enable AWS GuardDuty"
  type        = bool
  default     = true
}

variable "enable_config" {
  description = "Enable AWS Config"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 365
} 