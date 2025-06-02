variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "org_name" {
  description = "Organization name for resource tagging"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 365
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
} 