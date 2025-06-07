resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

module "app_storage_account" {
  source = "../modules/terraform-azurerm-storageaccount"
  
  name = "${var.environment}${var.region}${replace(var.app_name, "-", "")}${random_string.suffix.result}"
  resource_group_name = module.app-rg.name
  location = var.location
  account_tier = "Standard"
  account_replication_type = "LRS"

    tags = {
        environment = "DevOps_Task_2"
    }
}

resource "azurerm_storage_table" "function_table" {
  name                 = "functiontable"
  storage_account_name = module.app_storage_account.name
}

resource "azurerm_private_endpoint" "storage_pe" {
  name                = "${var.environment}-${var.region}-${var.app_name}-storage-pe"
  location            = var.location
  resource_group_name = module.app-rg.name
  subnet_id           = module.network.subnets["FunctionSubnet"].id

  private_service_connection {
    name                           = "${var.environment}-${var.region}-${var.app_name}-storage-psc"
    is_manual_connection           = false
    private_connection_resource_id = module.app_storage_account.id
    subresource_names              = ["table"]
  }

  tags = {
    environment = "DevOps_Task_2"
  }
}
