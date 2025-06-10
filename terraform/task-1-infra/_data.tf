data "archive_file" "app_zip" {
  type        = "zip"
  source_dir  = "../../web_app"
  output_path = "${path.module}/app.zip"
}

data "azurerm_client_config" "current" {}