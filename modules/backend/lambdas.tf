resource "aws_lambda_function" "pronto_api_reminder" {
  filename      = "/dev/null" # Dummy file name
  function_name = "pronto_api_reminder"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.pronto_reminder_role.arn
  handler       = "dist/index.handler"
  timeout       = 180

  vpc_config {
    security_group_ids = [var.allow_all_egress_id]
    subnet_ids         = var.private_subnet_ids
  }

  environment {
    variables = {
      TWILIO_AUTH_TOKEN  = var.TWILIO_AUTH_TOKEN
      TWILIO_ACCOUNT_SID = var.TWILIO_SID
      TWILIO_PHONE       = var.TWILIO_PHONE
    }
  }
}

output "pronto_api_reminder_function_arn" {
  value = aws_lambda_function.pronto_api_reminder.arn
}
