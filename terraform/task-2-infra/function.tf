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
  subscription_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  app_settings = {
    AzureWebJobsStorage = "UseManagedIdentity=true;Endpoint=https://${module.app_storage_account.name}.table.core.windows.net"
    AzureWebJobsSecretStorageType = "Files"
    AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id #this might need to be changed
    AZURE_TENANT_ID = data.azurerm_client_config.current.tenant_id
    STORAGE_TABLE_NAME = azurerm_storage_table.function_table.name
    STORAGE_ACCOUNT_NAME = module.app_storage_account.name
  }

  tags = {
    environment = "DevOps_Task_2"
  }

  depends_on = [ module.app_storage_account ]
}