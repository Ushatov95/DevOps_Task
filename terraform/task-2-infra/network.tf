module "network" {
  source = "../modules/terraform-azurerm-network"

  name = "${var.environment}-${var.region}-${var.app_name}-vnet"
  resource_group_name = module.app-rg.name
  location = var.location
  cidr = "192.168.192.0/25"

  subnets = {
    FunctionSubnet = {
      name = "${var.environment}-${var.region}-${var.app_name}-subnet-function"
      address_prefix = "192.168.192.0/26"
    }
    DummySubnet = {
      name = "${var.environment}-${var.region}-${var.app_name}-subnet-dummy"
      address_prefix = "192.168.192.64/26"
    }
  }

  tags = {
    environment = "DevOps_Task_2"
  }

  depends_on = [ module.app-rg ]
}