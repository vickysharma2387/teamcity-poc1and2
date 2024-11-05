variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_count" {
  default = 1
}

variable "env_name" {
  description = "Environment name for tagging"
  type        = string
}

variable "product_name" {
  description = "Product name for tagging"
  type        = string
}
