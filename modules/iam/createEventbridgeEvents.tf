resource "aws_iam_role" "write_eventbridge_events" {
    name = "write_eventbridge_events"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
    

    inline_policy {
        name = "write_eventbridge_events_policy"

        policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action   = [
                    "events:PutRule",
                    "events:PutTargets",
                    "events:DeleteRule",
                    "events:RemoveTargets"
                ]

                Effect   = "Allow"
                Resource = "*"
            }
        ]
        })
    }
}

resource "aws_iam_role" "read_eventbridge_events" {
    name = "read_eventbridge_events"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
    

    inline_policy {
      name = "read_eventbridge_events_policy"

        policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action   = [
                    "events:DescribeRule",
                    "events:ListRules",
                    "events:ListTargetsByRule",
                    "events:ListRuleNamesByTarget"
                ]

                Effect   = "Allow"
                Resource = "*"
            }
        ]
        })
    }
}

output "write_eventbridge_events" {
  value = aws_iam_role.write_eventbridge_events.arn
}

output "read_eventbridge_events" {
  value = aws_iam_role.read_eventbridge_events.arn
}