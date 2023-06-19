resource "aws_apigatewayv2_api" "pronto_api" {
  name          = "pronto-api"
  protocol_type = "HTTP"

  cors_configuration {
    expose_headers = [
      "set-cookie",
      "Cookie"
    ]
    allow_headers = [
      "Content-Type",
      "set-cookie",
      "Origin",
      "Accept",
      "X-XSS-Protection"
    ]
    allow_methods = [
      "GET",
      "POST"
    ]
    allow_origins = ["localhost:3000"]
  }
}

resource "aws_apigatewayv2_stage" "pronto_api_gateway_state" {
  api_id      = aws_apigatewayv2_api.pronto_api.id
  name        = var.api_gateway_stage
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "pronto_api_integration" {
  api_id           = aws_apigatewayv2_api.pronto_api.id
  integration_type = "AWS_PROXY"

  connection_type    = "INTERNET"
  integration_method = "ANY"
  integration_uri    = aws_lambda_function.pronto_api.invoke_arn
}

resource "aws_apigatewayv2_integration" "pronto_api_reminder_integration" {
  api_id           = aws_apigatewayv2_api.pronto_api.id
  integration_type = "AWS_PROXY"

  connection_type    = "INTERNET"
  integration_method = "ANY"
  integration_uri    = aws_lambda_function.pronto_api_reminder.invoke_arn
}

resource "aws_apigatewayv2_route" "graphql" {
  api_id    = aws_apigatewayv2_api.pronto_api.id
  route_key = "ANY /graphql/{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.pronto_api_integration.id}"
}

resource "aws_apigatewayv2_route" "reminder" {
  api_id    = aws_apigatewayv2_api.pronto_api.id
  route_key = "ANY /reminder/{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.pronto_api_reminder_integration.id}"
}

resource "aws_lambda_permission" "api_gateway_pronto_api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pronto_api.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_apigatewayv2_api.pronto_api.execution_arn}/*/*"
}


resource "aws_lambda_permission" "api_gateway_pronto_api_reminder" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pronto_api_reminder.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_apigatewayv2_api.pronto_api.execution_arn}/*/*"
}
