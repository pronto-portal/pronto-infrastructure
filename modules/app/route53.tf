data "aws_route53_zone" "pronto_public_zone" {
  name = "prontotranslationservices.com"
}

resource "aws_route53_record" "pronto_api_domain" {
  name    = aws_apigatewayv2_domain_name.pronto_api_domain.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.pronto_public_zone.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.pronto_api_domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.pronto_api_domain.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
