terraform {
  backend "s3" {
    bucket         = "terraform-backend-teamcity1"
    key            = "terraform/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "DT-terraform-backend-teamcity1"
    encrypt        = true
  }
}
