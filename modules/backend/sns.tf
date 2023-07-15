resource "aws_sns_sms_preferences" "sms_preferences" {
  default_sms_type = "Transactional"
}

resource "aws_sns_topic" "bounce" {
  name = "bounce-topic"
}

resource "aws_sns_topic" "complaint" {
  name = "complaint-topic"
}

resource "aws_sns_topic_subscription" "bounce_subscription" {
  topic_arn = aws_sns_topic.bounce.arn
  protocol  = "email"
  endpoint  = "brandonberke@gmail.com" // todo: Replace with pronto email and set up Email workspace in G-Suite or AWS
}

resource "aws_sns_topic_subscription" "complain_subscription" {
  topic_arn = aws_sns_topic.complaint.arn
  protocol  = "email"
  endpoint  = "brandonberke@gmail.com" // todo: Replace with pronto email and set up Email workspace in G-Suite or AWS
}