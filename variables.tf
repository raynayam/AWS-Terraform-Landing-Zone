variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "org_name" {
  description = "Organization name for resource tagging"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
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

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "sso_provider" {
  description = "SSO provider configuration"
  type = object({
    name     = string
    type     = string
    metadata = string
  })
  default = null
}

variable "break_glass_users" {
  description = "List of break glass users"
  type        = list(string)
  default     = []
}

variable "admin_users" {
  description = "List of admin users"
  type        = list(string)
  default     = []
}

variable "readonly_users" {
  description = "List of read-only users"
  type        = list(string)
  default     = []
}

variable "subnet_config" {
  description = "Subnet configuration"
  type = object({
    public_subnets  = list(string)
    private_subnets = list(string)
    data_subnets    = list(string)
  })
  default = {
    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
    data_subnets    = ["10.0.5.0/24", "10.0.6.0/24"]
  }
} 