#Lambda function
resource "aws_lambda_function" "lambdafunc_resizer" {
  function_name = "lambda_resizer"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_role.arn
  filename      = "../Lambda/lambda_function_payload.zip"
  handler       = "lambda.lambda_handler"
  layers        = [aws_lambda_layer_version.my_resizer_layer.arn]

}
#Document for lambda function
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../Lambda/lambda.py"
  output_path = "../Lambda/lambda_function_payload.zip"
}
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Action" : "sts:AssumeRole",
      "Principal" : {
        "Service" : "lambda.amazonaws.com"
      },
      "Effect" : "Allow",
      "Sid" : ""
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_execution_attachment" {
  name       = "lambda_basic_execution"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}

#Lambda Layer
resource "aws_lambda_layer_version" "my_resizer_layer" {
  layer_name          = "my_resizer_layer"
  compatible_runtimes = ["python3.8"]
  filename            = "../Lambda/package.zip"

}
