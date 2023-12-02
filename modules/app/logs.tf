resource "aws_cloudwatch_log_group" "pronto_api_gateway" {
  name              = "api-gateway"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "pronto_ecs" {
  name              = "ecs"
  retention_in_days = 3
}
resource "aws_cloudwatch_log_group" "pronto_reminder_lambda" {
  name = "/aws/lambda/${aws_lambda_function.pronto_api_reminder.function_name}"
}
