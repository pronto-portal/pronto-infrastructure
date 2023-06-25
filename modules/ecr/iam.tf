resource "aws_iam_policy" "ecr_image_pull" {
  name = "ecr-image-pull"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:GetAuthorizationToken",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          aws_ecr_repository.pronto_ecr.arn
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
        ],
        "Resource" : "*"
      }
    ]
  })
}

output "ecr_image_pull_policy_arn" {
  value = aws_iam_policy.ecr_image_pull.arn
}
