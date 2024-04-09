#Random String
resource "random_string" "random_name" {
  length  = 16
  special = false
  numeric = false
  lower   = true
  upper   = false
  count   = 2
}

#Bucket 1: Original images storage
resource "aws_s3_bucket" "bucket1" {
  bucket = "bucket-${random_string.random_name[0].result}"
}
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.func.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket1.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambdafunc_resizer.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}

#Bucket 2: Resized images storage
resource "aws_s3_bucket" "bucket2" {
  bucket = "bucket-${random_string.random_name[1].result}"
}

#Lambda function
resource "aws_lambda_function" "lambdafunc_resizer" {
  function_name = "lambda_resizer"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  filename      = "lambda_function_payload.zip"

}
#Document for lambda function
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "lambda_function_payload.zip"
}

#role for lambda function
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

}
