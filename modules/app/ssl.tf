data "aws_acm_certificate" "pronto_issued_certificate" {
  domain   = "prontotranslationservices.com"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "pronto_api_issued_certificate" {
  domain   = "api.prontotranslationservices.com"
  statuses = ["ISSUED"]
}
