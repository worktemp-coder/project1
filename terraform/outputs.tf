output "bucket_name" {
  description = "Name of the secure assets bucket"
  value       = aws_s3_bucket.capstone_assets.id
}

output "security_group_id" {
  description = "ID of the capstone security group"
  value       = aws_security_group.capstone_sg.id
}