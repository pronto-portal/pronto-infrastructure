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

resource "aws_ses_identity_notification_topic" "bounce" {
  topic_arn         = aws_sns_topic.bounce.arn
  notification_type = "Bounce"
  identity          = aws_ses_domain_identity.pronto_ses_domain_identity.id
}

resource "aws_ses_identity_notification_topic" "complaint" {
  topic_arn         = aws_sns_topic.complaint.arn
  notification_type = "Complaint"
  identity          = aws_ses_domain_identity.pronto_ses_domain_identity.id
}
