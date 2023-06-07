resource "aws_s3_bucket" "pronto_artifacts" {
  bucket = "pronto-artifacts"

  tags = {
    App = "pronto"
  }
}
