resource "aws_iam_policy" "cloudwatch_logging" {
  name = "put_cloudwatch_events"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:logs:*:*:*"]
      }
    ]
  })
}

output "cloudwatch_logging_arn" {
  value = aws_iam_policy.cloudwatch_logging.arn
}
