#SNS Topic
resource "aws_sns_topic" "resizer_updates" {
  name = "resizer-updates-topic"
}

#Lambda Suscription
resource "aws_lambda_permission" "sns_invoke_permissions" {
  statement_id = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambdafunc_resizer.function_name
  principal     = "sns.amazonaws.com"

  source_arn = aws_sns_topic.resizer_updates.arn
}

# Crear la suscripción al correo electrónico en el tema SNS
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.resizer_updates.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"  # Cambia al correo electrónico deseado
}
# Agregar una política SNS para permitir que SNS envíe correos electrónicos
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
# Data source para obtener el ID de la cuenta AWS actual
data "aws_caller_identity" "current" {}