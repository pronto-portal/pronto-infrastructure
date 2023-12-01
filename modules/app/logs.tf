resource "aws_cloudwatch_log_group" "pronto_api_gateway" {
  name              = "api-gateway"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "pronto_ecs" {
  name       = "ecs"
  kms_key_id = aws_kms_key.pronto-ecs-kms.key_id
}
resource "aws_cloudwatch_log_group" "pronto_reminder_lambda" {
  name = "/aws/lambda/${aws_lambda_function.pronto_api_reminder.function_name}"
}
