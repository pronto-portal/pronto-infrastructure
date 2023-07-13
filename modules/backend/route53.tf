# data "aws_route53_zone" "pronto_public_zone" {
#   name = "prontotranslationservices.com"
# }

# resource "aws_route53_record" "pronto_ses_record" {
#   zone_id = data.aws_route53_zone.pronto_public_zone.zone_id
#   name    = "_amazonses.${aws_ses_domain_identity.pronto_ses_domain_identity.id}"
#   type    = "TXT"
#   ttl     = "600"
#   records = [aws_ses_domain_identity.pronto_ses_domain_identity.verification_token]
# }
