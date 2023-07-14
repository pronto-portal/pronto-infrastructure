resource "aws_sns_sms_preferences" "sms_preferences" {
  default_sms_type = "Transactional"
}

resource "aws_sns_topic" "bounce" {
  name = "bounce-topic"
}

resource "aws_sns_topic" "complaint" {
  name = "complaint-topic"
}
