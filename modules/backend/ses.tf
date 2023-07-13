resource "aws_ses_domain_identity" "pronto_ses_domain_identity" {
  domain = "prontotranslationservices.com"
}

resource "aws_ses_email_identity" "pronto_reminder_email_identity" {
  email = "reminder@prontotranslationservices.com"
}

resource "aws_ses_domain_identity_verification" "pronto_ses_domain_identity_verification" {
  domain = aws_ses_domain_identity.pronto_ses_domain_identity.id

  depends_on = [aws_route53_record.pronto_ses_record]
}
