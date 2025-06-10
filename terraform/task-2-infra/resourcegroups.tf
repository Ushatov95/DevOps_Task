module "app-rg" {
  source = "../modules/terraform-azurerm-resourcegroup"

  name     = "${var.environment}-${var.region}-${var.app_name}-rg"
  location = var.location

  tags = {
    environment = "DevOps_Task_2"
  }
}