resource "aws_s3_bucket" "pronto_artifacts" {
  bucket = "pronto-artifacts"

  tags = {
    App = "pronto"
  }
}

resource "aws_s3_bucket_acl" "pronto_artifacts_acl" {
  bucket = aws_s3_bucket.pronto_artifacts.id
  acl    = "private"
}

output "pronto_artifacts_s3_bucket" {
  value = aws_s3_bucket.pronto_artifacts.bucket
}
