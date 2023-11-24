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
      TWILIO_AUTH_TOKEN  = local.reminder_env_secret["TWILIO_AUTH_TOKEN"]
      TWILIO_ACCOUNT_SID = local.reminder_env_secret["TWILIO_SID"]
      TWILIO_PHONE       = local.reminder_env_secret["TWILIO_PHONE"]
    }
  }
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventbridgeRules"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pronto_api_reminder.function_name
  principal     = "events.amazonaws.com"
}
