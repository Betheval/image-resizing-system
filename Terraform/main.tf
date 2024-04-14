#Random String
resource "random_string" "random_name" {
  length  = 16
  special = false
  numeric = false
  lower   = true
  upper   = false
}

#Bucket 1: Original images storage
resource "aws_s3_bucket" "bucket1" {
  bucket = "bucket-${random_string.random_name.result}"
}
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambdafunc_resizer.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket1.arn
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
  bucket = "mvgpbucket2-specificname24"
}

