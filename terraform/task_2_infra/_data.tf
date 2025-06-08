data "archive_file" "app_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../func_app"
  output_path = "${path.module}/funcapp.zip"
}