resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.bucket_name
}
 
resource "aws_s3_bucket_notification" "bucket_notification" {
bucket = aws_s3_bucket.lambda_bucket.id
 
  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".zip"
  }
}
 
resource "aws_s3_bucket_policy" "bucket_policy" {
bucket = aws_s3_bucket.lambda_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
Service = "lambda.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.lambda_bucket.arn}/*"
      }
    ]
  })
}