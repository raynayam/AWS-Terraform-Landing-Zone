locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.org_name
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = "vpc-${var.environment}"
    }
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.subnet_config.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_config.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "public-subnet-${count.index + 1}-${var.environment}"
      Tier = "Public"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.subnet_config.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_config.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "private-subnet-${count.index + 1}-${var.environment}"
      Tier = "Private"
    }
  )
}

# Data Subnets
resource "aws_subnet" "data" {
  count             = length(var.subnet_config.data_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_config.data_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "data-subnet-${count.index + 1}-${var.environment}"
      Tier = "Data"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "igw-${var.environment}"
    }
  )
}

# NAT Gateways
resource "aws_eip" "nat" {
  count = length(var.subnet_config.public_subnets)
  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "nat-eip-${count.index + 1}-${var.environment}"
    }
  )
}

resource "aws_nat_gateway" "main" {
  count         = length(var.subnet_config.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    local.common_tags,
    {
      Name = "nat-${count.index + 1}-${var.environment}"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

# Transit Gateway
resource "aws_ec2_transit_gateway" "main" {
  description = "Transit Gateway for ${var.environment}"
  
  tags = merge(
    local.common_tags,
    {
      Name = "tgw-${var.environment}"
    }
  )
}

# VPC Flow Logs
resource "aws_flow_log" "main" {
  count           = var.enable_flow_logs ? 1 : 0
  iam_role_arn    = aws_iam_role.flow_log.0.arn
  log_destination = aws_cloudwatch_log_group.flow_log.0.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id

  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "flow_log" {
  count           = var.enable_flow_logs ? 1 : 0
  name            = "/aws/vpc/flow-logs/${var.environment}"
  retention_in_days = 30

  tags = local.common_tags
}

resource "aws_iam_role" "flow_log" {
  count = var.enable_flow_logs ? 1 : 0
  name  = "vpc-flow-log-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy" "flow_log" {
  count = var.enable_flow_logs ? 1 : 0
  name  = "vpc-flow-log-policy-${var.environment}"
  role  = aws_iam_role.flow_log.0.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
} 