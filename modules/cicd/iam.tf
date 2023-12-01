resource "aws_iam_policy" "codebuild_vpc_policy" {
  name = "codebuild_vpc_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ]

        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ec2:CreateNetworkInterfacePermission"
        ]

        Effect = "Allow"
        Resource = [
          "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:network-interface/*"
        ]
        Condition = {
          StringEquals = {
            "ec2:AuthorizedService" = "codebuild.amazonaws.com"
          }
          ArnEquals = {
            "ec2:Subnet" = var.private_subnet_arns
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "codebuild_logging_policy" {
  name = "codebuild_logging_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]

        Effect   = "Allow"
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
      }
    ]
  })
}

resource "aws_iam_role" "codebuild_backend_service_role" {
  name = "codebuild_backend_service_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })


  inline_policy {
    name = "codebuild_service_role_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [

        {
          Action = [
            "ecs:UpdateService",
            "ecs:DescribeServices"
          ]

          Effect = "Allow"
          Resource = [
            var.ecs_service_backend_id
          ]
        },
        {
          Action = [
            "ecs:ListTaskDefinitions"
          ]

          Effect = "Allow"
          Resource = [
            var.ecs_task_definition_backend_arn
          ]
        },
        {
          Action = [
            "iam:PassRole"
          ]

          Effect = "Allow"
          Resource = [
            var.pronto_ecs_task_execution_backend_arn
          ]
        },
        {
          Action = [
            "ecs:RegisterTaskDefinition"
          ]

          Effect   = "Allow"
          Resource = "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "lambda:UpdateFunctionCode"
          ],
          "Resource" : [var.pronto_api_reminder_function_arn]
        }
      ]
    })
  }
}

resource "aws_iam_role" "codebuild_frontend_service_role" {
  name = "codebuild_frontend_service_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })


  inline_policy {
    name = "codebuild_service_role_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ecs:UpdateService",
            "ecs:DescribeServices"
          ]

          Effect = "Allow"
          Resource = [
            var.ecs_service_frontend_id
          ]
        },
        {
          Action = [
            "ecs:ListTaskDefinitions"
          ]

          Effect = "Allow"
          Resource = [
            var.ecs_task_definition_frontend_arn
          ]
        },
        {
          Action = [
            "iam:PassRole"
          ]

          Effect = "Allow"
          Resource = [
            var.pronto_ecs_task_execution_frontend_arn
          ]
        },
        {
          Action = [
            "ecs:RegisterTaskDefinition"
          ]

          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_role_policy_attachment" "codebuild_service_role_vpc" {
  role       = aws_iam_role.codebuild_backend_service_role.name
  policy_arn = aws_iam_policy.codebuild_vpc_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuild_service_role_logging" {
  role       = aws_iam_role.codebuild_backend_service_role.name
  policy_arn = aws_iam_policy.codebuild_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuild_service_role_image_pull" {
  role       = aws_iam_role.codebuild_backend_service_role.name
  policy_arn = var.ecr_image_pull_policy_arn
}

resource "aws_iam_role_policy_attachment" "codebuild_frontend_service_role_vpc" {
  role       = aws_iam_role.codebuild_frontend_service_role.name
  policy_arn = aws_iam_policy.codebuild_vpc_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuild_frontend_service_role_logging" {
  role       = aws_iam_role.codebuild_frontend_service_role.name
  policy_arn = aws_iam_policy.codebuild_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuild_frontend_service_role_image_pull" {
  role       = aws_iam_role.codebuild_frontend_service_role.name
  policy_arn = var.ecr_image_pull_policy_arn
}
