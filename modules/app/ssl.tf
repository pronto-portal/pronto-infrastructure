data "aws_acm_certificate" "pronto_issued_certificate" {
  domain   = "prontotranslationservices.com"
  statuses = ["ISSUED"]
}
