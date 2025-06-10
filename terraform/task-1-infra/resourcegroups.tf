module "web-rg" {
  source = "../modules/terraform-azurerm-resourcegroup"

  name     = "${var.environment}-${var.region}-${var.web_name}-rg"
  location = var.location

  tags = {
    environment = "DevOps_Task_1"
  }
}