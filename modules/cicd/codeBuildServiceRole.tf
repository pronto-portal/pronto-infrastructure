resource "aws_iam_role" "codebuild_service_role" {
    name = "codebuild_service_role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
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
                Action   = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                    "ec2:DescribeSubnets",
                    "ec2:DescribeSecurityGroups"

                ]

                Effect   = "Allow"
                Resource = "*"
            },
            {
                Effect  = "Allow"
                Action = ["s3:*"]
                Resource = [
                  aws_s3_bucket.pronto_artifacts.arn
                ]
            }
        ]
        })
    }
} 
