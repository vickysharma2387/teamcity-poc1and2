provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source     = "./Modules/vpc"
  env_name   = var.env_name
  product_name = var.product_name
}

module "ecs-ec2" {
  source       = "./Modules/ecs-ec2"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.subnet_ids[0]
  security_groups = [module.security_group.security_group_id]
  env_name       = var.env_name
  product_name   = var.product_name
}

module "security_group" {
  source       = "./Modules/security_group"
  vpc_id       = module.vpc.vpc_id
  env_name     = var.env_name
  product_name = var.product_name
}

module "ecr" {
  source     = "./Modules/ecr"
  env_name   = var.env_name
  product_name = var.product_name
}

module "s3_bucket" {
  source      = "./Modules/s3"
  env_name       = var.env_name
  product_name   = var.product_name
}

module "lambda" {
  source                 = "./Modules/lambda"
  env_name               = var.env_name
  product_name           = var.product_name
  lambda_zip_path        = "lambda_function.zip"
  environment_variables  = {
    KEY = "value"
  }
}
