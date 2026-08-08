variable "aws_region" {
  description = "AWS region for the capstone app"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket for app assets"
  type        = string
  default     = "capstone-devsecops-assets"
}

variable "environment" {
  description = "Deployment environment tag"
  type        = string
  default     = "production"
}