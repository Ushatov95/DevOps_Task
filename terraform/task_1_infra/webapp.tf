resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

module "web_app" {
  source = "../modules/terraform-azurerm-webapp"

  app_name              = "${var.environment}-${var.region}-${var.web_name}-app-${random_string.suffix.result}"
  app_service_plan_name = "${var.environment}-${var.region}-${var.web_name}-asp-${random_string.suffix.result}"
  resource_group_name   = module.web-rg.name
  location              = var.location
  environment           = var.environment
  sku_name             = "B1"
  os_type              = "Linux"
  node_version         = "20-lts"

  tags = {
    environment = "DevOps_Task_1"
  }
}

# Create a zip file for deployment since there was issue in using zip_file directly in the module
resource "null_resource" "deploy_zip" {
  depends_on = [module.web_app]

  provisioner "local-exec" {
    command = "az webapp deploy --resource-group ${module.web-rg.name} --name ${module.web_app.webapp_name} --src-path ./app.zip --type zip"
  }
}