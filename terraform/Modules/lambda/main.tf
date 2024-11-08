resource "aws_lambda_function" "lambda_function" {
  function_name    = var.function_name
  s3_bucket        = var.s3_bucket
  s3_key           = var.s3_key
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_role.arn
}
 
resource "aws_iam_role" "lambda_role" {
  name = "lambda-s3-execution-role"
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
 
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-s3-policy"
role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = "*"
      }
    ]
  })
}