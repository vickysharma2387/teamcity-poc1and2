resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.product_name}-${var.env_name}-s3"
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

