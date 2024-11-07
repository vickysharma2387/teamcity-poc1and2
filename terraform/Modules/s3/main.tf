data "aws_caller_identity" "current" {}
 
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.product_name}-${var.env_name}-s3"
}
 
resource "aws_s3_bucket_public_access_block" "lambda_bucket_block" {
bucket = aws_s3_bucket.lambda_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
 
# S3 bucket policy with controlled access
resource "aws_s3_bucket_policy" "lambda_bucket_policy" {
bucket = aws_s3_bucket.lambda_bucket.id
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:*",
        "Resource": [
          "${aws_s3_bucket.lambda_bucket.arn}",
          "${aws_s3_bucket.lambda_bucket.arn}/*"
        ]
      }
    ]
  }
  POLICY
}