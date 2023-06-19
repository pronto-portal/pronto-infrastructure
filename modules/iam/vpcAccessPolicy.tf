resource "aws_iam_policy" "vpc_access_policy" {
  name = "vpc_access_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSecurityGroups"
        ]
        Resource = "*"
      }
    ]
  })
}

output "vpc_access_policy_arn" {
  value = aws_iam_policy.vpc_access_policy.arn
}
