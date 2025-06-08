data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

module "function_app" {
  source = "../modules/terraform-azurerm-functionapp"

  funapp_name = "${var.environment}-${var.region}-${var.app_name}-function-${random_string.suffix.result}"
  app_service_plan_name = "${var.environment}-${var.region}-${var.app_name}-asp-${random_string.suffix.result}"
  resource_group_name = module.app-rg.name
  location = var.location
  environment = var.environment
  sku_name = "B1"
  os_type = "Linux"
  python_version = "3.10"
  storage_account_name = module.app_storage_account.name
  storage_account_id = module.app_storage_account.id
  TABLE_STORAGE_NAME = azurerm_storage_table.function_table.name
  TABLE_STORAGE_URL = "https://${module.app_storage_account.name}.table.core.windows.net"
  network_id = module.network.vnet_id

  app_settings = {
    AzureWebJobsStorage = "UseManagedIdentity=true;Endpoint=https://${module.app_storage_account.name}.table.core.windows.net"
    FUNCTIONS_WORKER_RUNTIME = "python"
    AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
    AZURE_TENANT_ID = data.azurerm_client_config.current.tenant_id
    TABLE_STORAGE_NAME = azurerm_storage_table.function_table.name
    TABLE_STORAGE_URL = "https://${module.app_storage_account.name}.table.core.windows.net"
  }

  tags = {
    environment = "DevOps_Task_2"
  }

  depends_on = [ module.app_storage_account ]
}

resource "time_sleep" "wait_for_functionapp" {
  depends_on = [module.function_app]
  create_duration = "60s"
}

# Create a zip file for deployment since there was issue in using zip_file directly in the module
resource "null_resource" "deploy_zip" {
  depends_on = [time_sleep.wait_for_functionapp]

  provisioner "local-exec" {
    command = "az functionapp deployment source config-zip --resource-group ${module.app-rg.name} --name ${module.function_app.funapp_name} --src ./funcapp.zip"
  }
}