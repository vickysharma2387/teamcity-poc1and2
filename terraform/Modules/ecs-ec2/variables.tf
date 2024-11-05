variable "instance_type" {
  default = "t2.micro"
}

variable "env_name" {
  description = "Environment name for tagging"
  type        = string
}

variable "product_name" {
  description = "Product name for tagging"
  type        = string
}

variable "security_groups" {
  description = "List of security groups to associate with the instance"
  type        = list(string)
  default     = []
}
