#SNS Topic
resource "aws_sns_topic" "resizer_updates" {
  name = "resizer-updates-topic"
}

resource "aws_lambda_permission" "sns_invoke_permissions" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambdafunc_resizer.function_name
  principal     = "sns.amazonaws.com"

  source_arn = aws_sns_topic.resizer_updates.arn
}


resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.resizer_updates.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"
}

resource "aws_sns_topic_policy" "example_topic_policy" {
  arn = aws_sns_topic.resizer_updates.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "example_topic_policy",
  "Statement": [
    {
      "Sid": "AllowSNSPublish",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sns:Publish",
      "Resource": "${aws_sns_topic.resizer_updates.arn}",
      "Condition": {
        "StringEquals": {
          "AWS:SourceAccount": "${data.aws_caller_identity.current.account_id}"
        }
      }
    }
  ]
}
POLICY
}

data "aws_caller_identity" "current" {}
