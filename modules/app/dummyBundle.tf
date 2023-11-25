data "archive_file" "dummy_bundle" {
  type        = "zip"
  source_dir  = "${path.module}/dummyLambda"
  output_path = "${path.module}/dummyLambda.zip"
}
