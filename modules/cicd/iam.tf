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

                ]

                Effect   = "Allow"
                Resource = "*"
            },
            {
                Effect  = "Allow"
                Action = ["s3:*"]
                resources = [
                Resource = aws_s3_bucket.pronto_artifacts.arn
                ]
            }
        ]
        })
    }
} 