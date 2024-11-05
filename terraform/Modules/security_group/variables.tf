variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "env_name" {
  description = "Environment name for tagging"
  type        = string
}

variable "product_name" {
  description = "Product name for tagging"
  type        = string
}