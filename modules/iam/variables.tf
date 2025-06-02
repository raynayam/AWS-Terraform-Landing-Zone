variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "org_name" {
  description = "Organization name for resource tagging"
  type        = string
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

variable "sso_provider" {
  description = "SSO provider configuration"
  type = object({
    name     = string
    type     = string
    metadata = string
  })
  default = null
} 