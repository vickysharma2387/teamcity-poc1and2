data "aws_caller_identity" "current" {}
 
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.product_name}-${var.env_name}-s3"
}
 
# Block public access settings for the bucket
resource "aws_s3_bucket_public_access_block" "lambda_bucket_block" {
bucket = aws_s3_bucket.lambda_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
 
# Create a bucket policy with a dynamic bucket ARN
resource "aws_s3_bucket_policy" "lambda_bucket_policy" {
bucket = aws_s3_bucket.lambda_bucket.id
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
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
 
# Create an IAM policy to grant permissions to manage the S3 bucket dynamically
resource "aws_iam_policy" "s3_bucket_management_policy" {
  name        = "S3BucketManagementPolicy"
  description = "Policy to manage S3 bucket policy and public access block settings"
  policy      = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutBucketPolicy",
          "s3:GetBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:PutBucketPublicAccessBlock",
          "s3:GetBucketPublicAccessBlock"
        ],
        "Resource": [
          "${aws_s3_bucket.lambda_bucket.arn}",
          "${aws_s3_bucket.lambda_bucket.arn}/*"
        ]
      }
    ]
  }
  POLICY
}
 
# Extract the current IAM user name from the ARN
locals {
  current_user_name = regex("([^:/]+)$", data.aws_caller_identity.current.arn)[0]
}
 
# Attach the policy to the current IAM user
resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  user       = local.current_user_name
  policy_arn = aws_iam_policy.s3_bucket_management_policy.arn
}

resource "aws_s3_object" "lambda_function_zip" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key = "lambda_function.zip"
  source = "lambda_function.zip"
}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
 
  lambda_function {
    events = ["s3:ObjectCreated:*"] 
    lambda_function_arn = aws_lambda_function.lambda.arn
  }
 
  depends_on = [aws_lambda_function.lambda]
}

output "bucket_name" {
  value = aws_s3_bucket.lambda_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.lambda_bucket.arn
}