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
}

variable "subnet_config" {
  description = "Subnet configuration"
  type = object({
    public_subnets  = list(string)
    private_subnets = list(string)
    data_subnets    = list(string)
  })
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
} 