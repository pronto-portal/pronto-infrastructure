data "aws_iam_policy_document" "assume_role_lambda" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "pronto_reminder_rule" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "pronto_api_lambda_role" {
  name               = "pronto_api_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json
}

resource "aws_iam_role_policy" "pronto_api_lambda_create_events" {
  name = "pronto_api_lambda_create_events"
  role = aws_iam_role.pronto_api_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "events:PutRule",
          "events:PutTargets",
          "events:DeleteRule",
          "events:RemoveTargets",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "pronto_reminder_role" {
  name               = "pronto_reminder_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json
}

resource "aws_iam_role" "pronto_reminder_rule" {
  name               = "pronto_reminder_rule"
  assume_role_policy = data.aws_iam_policy_document.pronto_reminder_rule.json
}

resource "aws_iam_role_policy" "pronto_invoke_reminder_function" {
  name = "pronto_api_lambda_create_events"
  role = aws_iam_role.pronto_reminder_rule.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction"
        ]
        Effect   = "Allow"
        Resource = aws_lambda_function.pronto_api_reminder.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "pronto_api_lambda_role_vpc_access" {
  role       = aws_iam_role.pronto_api_lambda_role.id
  policy_arn = var.vpc_access_policy_arn
}

resource "aws_iam_role_policy_attachment" "pronto_reminder_role_vpc_access" {
  role       = aws_iam_role.pronto_reminder_role.id
  policy_arn = var.vpc_access_policy_arn
}
