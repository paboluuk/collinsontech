output "address" {
  value       = aws_db_instance.example.address
  description = "Connect database at this endpoint"
}
output "port" {
  value       = aws_db_instance.example.port
  description = "database port is listening on"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}