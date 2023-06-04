resource "aws_iam_role" "create_eventbridge_events" {
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
        name = "create_eventbridge_events_policy"

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

resource "aws_iam_role" "get_eventbridge_events" {
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
      name = "get_eventbridge_events_policy"

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