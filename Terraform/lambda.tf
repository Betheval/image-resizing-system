#Lambda function
resource "aws_lambda_function" "lambdafunc_resizer" {
  function_name = "lambda_resizer"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  filename      = "../Lambda/lambda_function_payload.zip"
  handler       = "lambda_handler"

}
#Document for lambda function
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../Lambda/lambda.py"
  output_path = "../Lambda/lambda_function_payload.zip"
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
