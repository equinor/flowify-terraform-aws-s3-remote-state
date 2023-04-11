# Outputs
# https://www.terraform.io/docs/configuration/outputs.html

output "bucket_region" {
  value = aws_s3_bucket.s3_backend[0].region
}

output "bucket_name" {
  value = aws_s3_bucket.s3_backend[0].id
}

output "bucket_arn" {
  value = aws_s3_bucket.s3_backend[0].arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_state_lock[0].id
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.terraform_state_lock[0].arn
}

