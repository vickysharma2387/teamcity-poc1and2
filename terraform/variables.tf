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
