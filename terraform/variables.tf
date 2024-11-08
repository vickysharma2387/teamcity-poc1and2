variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "product_name" {
  description = "Product name"
  type        = string
}

variable "lambda_code_bucket" {
  description = "The S3 bucket where the Lambda code zip file is stored"
  type        = string
}
 
variable "lambda_code_key" {
  description = "The S3 key for the Lambda code zip file"
  type        = string
}
