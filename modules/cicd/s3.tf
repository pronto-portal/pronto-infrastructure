resource "aws_s3_bucket" "pronto_artifacts" {
  bucket = "pronto_artifacts"

  tags = {
    App = "pronto"
  }
}