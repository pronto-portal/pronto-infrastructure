resource "aws_lambda_function" "pronto_api" {
  filename      = "/dev/null" # Dummy file name
  function_name = "pronto_api"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.pronto_api_lambda_role.arn
  handler       = "src/index.handler"
  timeout       = 180

  vpc_config {
    security_group_ids = [var.allow_all_egress_id]
    subnet_ids         = var.private_subnet_ids
  }

  environment {
    variables = {
      GOOGLE_CLIENT_ID        = var.GOOGLE_CLIENT_ID
      GOOGLE_CLIENT_SECRET_ID = var.GOOGLE_CLIENT_SECRET_ID
      JWT_SECRET              = var.JWT_SECRET
      REFRESH_SECRET          = var.REFRESH_SECRET
      TOKEN_ENCRYPT_SECRET    = var.TOKEN_ENCRYPT_SECRET
    }
  }
}

resource "aws_lambda_function" "pronto_api_reminder" {
  filename      = "/dev/null" # Dummy file name
  function_name = "pronto_api_reminder"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.pronto_reminder_role.arn
  handler       = "src/services/reminder/index.handler"
  timeout       = 180

  vpc_config {
    security_group_ids = [var.allow_all_egress_id]
    subnet_ids         = var.private_subnet_ids
  }

  environment {
    variables = {
      GOOGLE_CLIENT_ID        = var.GOOGLE_CLIENT_ID
      GOOGLE_CLIENT_SECRET_ID = var.GOOGLE_CLIENT_SECRET_ID
      JWT_SECRET              = var.JWT_SECRET
      REFRESH_SECRET          = var.REFRESH_SECRET
      TOKEN_ENCRYPT_SECRET    = var.TOKEN_ENCRYPT_SECRET
    }
  }
}

output "pronto_api_function_arn" {
  value = aws_lambda_function.pronto_api.arn
}

output "pronto_api_reminder_function_arn" {
  value = aws_lambda_function.pronto_api_reminder.arn
}
