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

resource "aws_iam_policy" "pronto_ecs_task_create_events" {
  name = "pronto_ecs_task_create_events"

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

resource "aws_iam_policy" "pronto_event_rule_invoke_reminder_function" {
  name = "pronto_event_rule_invoke_reminder_function"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : [
          "lambda:invokeFunction"
        ]
        "Resource" : [aws_lambda_function.pronto_api_reminder.arn]
      }
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

resource "aws_iam_role" "pronto_ecs_task_execution" {
  name = "pronto_ecs_task_execution"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role" "pronto_event_rule_role" {
  name = "pronto_event_rule_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "sns_delivery_status_role" {
  name = "sns_delivery_status_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "sns.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "pronto_ecs_user_policy" {
  name = "pronto_ecs_user_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:GetRole",
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Resource = [aws_iam_role.pronto_event_rule_role.arn]
      },

    ]
  })
}

resource "aws_iam_policy" "pronto_reminder_push_notifications_policy" {
  name = "pronto_reminder_push_notifications_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish",
          "sns:CheckIfPhoneNumberIsOptedOut",
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "pronto_ecs_user_worker_attachment" {
  user       = aws_iam_user.pronto_ecs_task_worker.name
  policy_arn = aws_iam_policy.pronto_ecs_user_policy.arn
}

resource "aws_iam_user_policy_attachment" "pronto_ecs_user_worker_events_attachment" {
  user       = aws_iam_user.pronto_ecs_task_worker.name
  policy_arn = aws_iam_policy.pronto_ecs_task_create_events.arn
}

resource "aws_iam_role_policy_attachment" "pronto_api_lambda_role_vpc_access" {
  role       = aws_iam_role.pronto_api_lambda_role.id
  policy_arn = var.vpc_access_policy_arn
}

resource "aws_iam_role_policy_attachment" "sns_delivery_status_role_logging" {
  role       = aws_iam_role.sns_delivery_status_role.id
  policy_arn = var.cloudwatch_logging_arn
}

resource "aws_iam_role_policy_attachment" "pronto_api_lambda_logging" {
  role       = aws_iam_role.pronto_api_lambda_role.id
  policy_arn = var.cloudwatch_logging_arn
}

resource "aws_iam_role_policy_attachment" "pronto_reminder_role_vpc_access" {
  role       = aws_iam_role.pronto_reminder_role.id
  policy_arn = var.vpc_access_policy_arn
}

resource "aws_iam_role_policy_attachment" "pronto_api_reminder_lambda_logging" {
  role       = aws_iam_role.pronto_reminder_role.id
  policy_arn = var.cloudwatch_logging_arn
}

resource "aws_iam_role_policy_attachment" "pronto_api_reminder_push_notifications" {
  role       = aws_iam_role.pronto_reminder_role.id
  policy_arn = aws_iam_policy.pronto_reminder_push_notifications_policy.arn
}

resource "aws_iam_role_policy_attachment" "pronto_ecs_task_execution" {
  role       = aws_iam_role.pronto_ecs_task_execution.id
  policy_arn = var.ecr_image_pull_policy_arn
}

resource "aws_iam_role_policy_attachment" "pronto_ecs_task_logging" {
  role       = aws_iam_role.pronto_ecs_task_execution.id
  policy_arn = var.cloudwatch_logging_arn
}

resource "aws_iam_role_policy_attachment" "pronto_ecs_task_create_events_attachment" {
  role       = aws_iam_role.pronto_ecs_task_execution.id
  policy_arn = aws_iam_policy.pronto_ecs_task_create_events.arn
}

resource "aws_iam_role_policy_attachment" "pronto_event_rule_role_invoke_function_attachment" {
  role       = aws_iam_role.pronto_event_rule_role.id
  policy_arn = aws_iam_policy.pronto_event_rule_invoke_reminder_function.arn
}

resource "aws_iam_user" "pronto_ecs_task_worker" {
  name = "Pronto_ecs_task_worker"
}

resource "aws_iam_access_key" "pronto_ecs_task_worker_key" {
  user = aws_iam_user.pronto_ecs_task_worker.name
}

resource "aws_iam_role" "ecs_task_exec_role" {
  name = "ecs_task_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_exec_policy" {
  name = "ecs_exec_policy"
  role = aws_iam_role.ecs_task_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",

        ],
        Resource = "*",
        Effect   = "Allow"
      }
    ]
  })
}
