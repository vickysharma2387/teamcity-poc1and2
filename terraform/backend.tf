terraform {
  backend "s3" {
    bucket         = "terraform-backend-teamcity"
    key            = "terraform/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "DT-terraform-backend-teamcity"
    encrypt        = true
  }
}
