provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source     = "./modules/vpc"
  env_name   = var.env_name
  product_name = var.product_name
}

module "ecs-ec2" {
  source       = "./modules/ecs-ec2"
  instance_type = "t2.micro"
  security_groups = [module.security_group.security_group_id]
  env_name       = var.env_name
  product_name   = var.product_name
}

module "security_group" {
  source       = "./modules/security_group"
  vpc_id       = module.vpc.vpc_id
  env_name     = var.env_name
  product_name = var.product_name
}
