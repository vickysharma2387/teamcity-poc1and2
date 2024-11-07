data "aws_caller_identity" "current" {}
 
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.product_name}-${var.env_name}-s3"
}
 
# S3 bucket policy with dynamic account ID
resource "aws_s3_bucket_policy" "lambda_bucket_policy" {
bucket = aws_s3_bucket.lambda_bucket.id
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/YOUR_ROLE_NAME"
        },
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