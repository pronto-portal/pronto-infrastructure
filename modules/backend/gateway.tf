resource "aws_apigatewayv2_api" "pronto_api" {
  name          = "pronto-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_credentials = true
    expose_headers    = ["set-cookie", "Cookie"]
    allow_headers = [
      "set-cookie",
      "Cookie",
      "Content-Type",
      "Origin",
      "Accept",
      "X-XSS-Protection",
      "Authorization",
    ]
    allow_methods = [
      "GET",
      "POST"
    ]
    allow_origins = ["http://localhost:3000", aws_lb.pronto_api_nlb.dns_name]
  }
}

resource "aws_apigatewayv2_vpc_link" "pronto_api_nlb_vpc_link" {
  name               = "pronto-api-nlb-vpc-link"
  subnet_ids         = var.private_subnet_ids
  security_group_ids = [aws_security_group.pronto_api_vpc_link_sg.id]
}

resource "aws_apigatewayv2_stage" "pronto_api_gateway_state" {
  api_id      = aws_apigatewayv2_api.pronto_api.id
  name        = var.api_gateway_stage
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.pronto_api_gateway.arn
    format = jsonencode({ "requestId" : "$context.requestId",
      "extendedRequestId" : "$context.extendedRequestId",
      "ip" : "$context.identity.sourceIp",
      "caller" : "$context.identity.caller",
      "user" : "$context.identity.user",
      "requestTime" : "$context.requestTime",
      "httpMethod" : "$context.httpMethod",
      "resourcePath" : "$context.resourcePath",
      "status" : "$context.status",
      "protocol" : "$context.protocol",
      "responseLength" : "$context.responseLength",
      "error" : "$context.error.message",
      "integrationError" : "$context.integrationErrorMessage",
      "integrationStatus" : "$context.integration.status"
    })
  }
}

resource "aws_apigatewayv2_integration" "pronto_api_graphql_integration" {
  api_id           = aws_apigatewayv2_api.pronto_api.id
  integration_type = "HTTP_PROXY"

  connection_type      = "VPC_LINK"
  integration_method   = "ANY"
  integration_uri      = aws_lb_listener.pronto_api_nlb_listener.arn
  connection_id        = aws_apigatewayv2_vpc_link.pronto_api_nlb_vpc_link.id
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "graphql" {
  api_id    = aws_apigatewayv2_api.pronto_api.id
  route_key = "ANY /graphql"

  target = "integrations/${aws_apigatewayv2_integration.pronto_api_graphql_integration.id}"
}
