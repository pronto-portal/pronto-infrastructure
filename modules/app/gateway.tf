resource "aws_apigatewayv2_api" "pronto_api" {
  name          = "pronto-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_credentials = true
    expose_headers    = ["set-cookie", "Cookie"]
    allow_headers = [
      "set-cookie",
      "Cookie",
      "Content-Type", "Content-Length",
      "Origin",
      "Accept", "Accept-Version",
      "X-XSS-Protection",
      "Authorization",
      "X-CSRF-Token",
      "X-Requested-With",
      "Content-MD5",
      "Date",
      "X-Api-Version",
      "X-Timezone"
    ]
    allow_methods = [
      "GET",
      "POST",
      "OPTIONS"
    ]
    allow_origins = [
      "https://${data.aws_acm_certificate.pronto_issued_certificate.domain}",
      "https://${aws_lb.pronto_ui_alb.dns_name}",
      "http://localhost:3000",
      "https://${data.aws_acm_certificate.pronto_api_issued_certificate.domain}"
    ]
  }
}

resource "aws_apigatewayv2_vpc_link" "pronto_api_alb_vpc_link" {
  name               = "pronto-api-alb-vpc-link"
  subnet_ids         = var.private_subnet_ids
  security_group_ids = [aws_security_group.pronto_api_vpc_link_sg.id]
}

resource "aws_apigatewayv2_domain_name" "pronto_api_domain" {
  domain_name = data.aws_acm_certificate.pronto_api_issued_certificate.domain

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.pronto_api_issued_certificate.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_stage" "pronto_api_gateway_stage" {
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

resource "aws_apigatewayv2_api_mapping" "pronto_api_domain_mapping" {
  api_id      = aws_apigatewayv2_api.pronto_api.id
  domain_name = aws_apigatewayv2_domain_name.pronto_api_domain.id
  stage       = aws_apigatewayv2_stage.pronto_api_gateway_stage.id
}
resource "aws_apigatewayv2_integration" "pronto_api_graphql_integration" {
  api_id           = aws_apigatewayv2_api.pronto_api.id
  integration_type = "HTTP_PROXY"

  connection_type      = "VPC_LINK"
  integration_method   = "ANY"
  integration_uri      = aws_lb_listener.pronto_api_alb_listener.arn
  connection_id        = aws_apigatewayv2_vpc_link.pronto_api_alb_vpc_link.id
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "graphql" {
  api_id    = aws_apigatewayv2_api.pronto_api.id
  route_key = "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.pronto_api_graphql_integration.id}"
}
