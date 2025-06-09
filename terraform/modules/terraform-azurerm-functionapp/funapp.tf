resource "azurerm_service_plan" "plan" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku_name
}

resource "azurerm_linux_function_app" "func_table_writer" {
  name                = var.funapp_name
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name       = var.storage_account_name
  service_plan_id            = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      python_version = var.python_version
    }
  }

  app_settings = var.app_settings

  identity {
    type = "SystemAssigned"
  }

  depends_on = [ azurerm_service_plan.plan ]
}

resource "azurerm_role_assignment" "func_blob_writer" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id = azurerm_linux_function_app.func_table_writer.identity[0].principal_id

  depends_on          = [ azurerm_linux_function_app.func_table_writer ]
}

resource "azurerm_role_assignment" "func_table_writer" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Table Data Contributor"
  principal_id = azurerm_linux_function_app.func_table_writer.identity[0].principal_id

  depends_on          = [ azurerm_linux_function_app.func_table_writer ]
}

resource "azurerm_role_assignment" "func_subscription_reader" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Reader"
  principal_id = azurerm_linux_function_app.func_table_writer.identity[0].principal_id

  depends_on          = [ azurerm_linux_function_app.func_table_writer ]
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_function_app.func_table_writer.id
  repo_url           = "https://github.com/Ushatov95/VnetScanner"
  branch             = "main"
  use_manual_integration = true
  use_mercurial      = false

  depends_on = [ azurerm_linux_function_app.func_table_writer ]
}