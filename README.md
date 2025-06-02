# AWS Landing Zone Terraform Module

This Terraform module creates a secure, scalable AWS landing zone with multi-account structure, centralized security, and shared services.

## Architecture Overview

- **Organizational Structure**: Management, Logging, and Production OUs
- **Network**: Hub-and-spoke topology with Transit Gateway
- **Security**: GuardDuty, Config Rules, and centralized logging
- **Shared Services**: Centralized logging, monitoring, and secrets management

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0.0
- AWS Organizations enabled
- AWS SSO configured (optional)

## Directory Structure

```
.
├── environments/
│   ├── dev/
│   └── prod/
├── modules/
│   ├── iam/
│   ├── network/
│   ├── security/
│   └── shared-services/
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

## Setup Instructions

1. Configure AWS credentials:
   ```bash
   aws configure
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Create a `terraform.tfvars` file with your configuration:
   ```hcl
   environment = "dev"
   org_name    = "your-org"
   aws_region  = "us-west-2"

   break_glass_users = ["arn:aws:iam::123456789012:user/break-glass"]
   admin_users       = ["arn:aws:iam::123456789012:user/admin"]
   readonly_users    = ["arn:aws:iam::123456789012:user/readonly"]

   sso_provider = {
     name     = "your-sso"
     type     = "SAML"
     metadata = "arn:aws:sso:::instance/ssoins-xxxxxxxxxxxxx"
   }
   ```
    Configure the S3 backend for Terraform state
    terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "landing-zone/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
    }

4. Apply the configuration:
   ```bash
   terraform plan
   terraform apply
   ```

## Security Considerations

- All resources are encrypted at rest
- IAM roles follow least privilege principle
- MFA is enforced for all admin access
- Network security is implemented using NACLs and Security Groups
- Centralized logging and monitoring

## Maintenance

- Regular security updates through AWS Systems Manager
- Automated compliance checks using AWS Config
- Centralized logging retention: 365 days

## License

MIT License
