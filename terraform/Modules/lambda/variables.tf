variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "env_name" {
  description = "Environment name for tagging"
  type        = string
}

variable "product_name" {
  description = "Product name for tagging"
  type        = string
}

variable "s3_bucket" {
  description = "The S3 bucket for the Lambda code"
  type        = string
}
 
variable "s3_key" {
  description = "The S3 key for the Lambda function code"
  type        = string
}