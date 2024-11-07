resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.product_name}-${var.env_name}-s3"
  acl    = "private"
}


