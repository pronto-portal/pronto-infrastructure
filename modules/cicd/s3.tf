resource "aws_s3_bucket" "pronto_artifacts" {
  bucket = "pronto-artifacts"

  tags = {
    App = "pronto"
  }
}

output "pronto_artifacts_s3_bucket" {
  value = aws_s3_bucket.pronto_artifacts.bucket
} 
