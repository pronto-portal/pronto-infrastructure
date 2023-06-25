resource "aws_iam_role" "codebuild_service_role" {
  name = "codebuild_service_role"
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
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
          ]

          Effect   = "Allow"
          Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeDhcpOptions",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeVpcs"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ec2:CreateNetworkInterfacePermission"
          ],
          "Resource" : "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:network-interface/*",
          "Condition" : {
            "StringEquals" : {
              "ec2:AuthorizedService" : "codebuild.amazonaws.com"
            },
            "ArnEquals" : {
              "ec2:Subnet" : var.private_subnet_arns
            }
          }
        }
      ]
    })
  }
}

resource "aws_iam_role_policy_attachment" "codebuild_service_role_image_pull" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = var.ecr_image_pull_policy_arn
}
// todo: decouple inline policies
