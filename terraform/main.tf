terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Secure S3 bucket for app assets
resource "aws_s3_bucket" "capstone_assets" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Project     = "capstone-devsecops"
  }
}

resource "aws_s3_bucket_public_access_block" "capstone_assets" {
  bucket                  = aws_s3_bucket.capstone_assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "capstone_assets" {
  bucket = aws_s3_bucket.capstone_assets.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "capstone_assets" {
  bucket = aws_s3_bucket.capstone_assets.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Security group — no SSH from internet
resource "aws_security_group" "capstone_sg" {
  name        = "capstone-sg"
  description = "Capstone app security group"
  tags = {
    Name        = "capstone-sg"
    Environment = var.environment
    Project     = "capstone-devsecops"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS from internet"
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS outbound"
  }
}