data "aws_iam_policy_document" "pronto_api_lambda_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole",
      "events:PutRule",
      "events:PutTargets",
      "events:DeleteRule",
    "events:RemoveTargets"]
  }
}

data "aws_iam_policy_document" "pronto_reminder_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole",
    "lambda:InvokeFunction"]

    resources = ["arn_of_lambda_goes_here"]
  }
}

resource "aws_iam_role" "pronto_api_lambda_role" {
  name               = "pronto_api_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.pronto_api_lambda_policy.json
}

resource "aws_iam_role" "pronto_reminder_role" {
  name               = "pronto_reminder_role"
  assume_role_policy = data.aws_iam_policy_document.pronto_reminder_policy
}
