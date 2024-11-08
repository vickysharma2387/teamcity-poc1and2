variable "env_name" {
  description = "Environment name for tagging"
  type        = string
}

variable "product_name" {
  description = "Product name for tagging"
  type        = string
}

variable "lambda_function_arn" {
  description = "The ARN of the Lambda function to be triggered"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}