output "env_name" {
  value = var.env_name
}

output "product_name" {
  value = var.product_name
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}
 
output "lambda_function_arn" {
  value = module.lambda.lambda_function_arn
}