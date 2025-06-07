locals {
  nsg_subnets = {
    for k in keys(azurerm_subnet.subnet) : k => azurerm_subnet.subnet[k]
    if azurerm_subnet.subnet[k].name != "AzureBastionSubnet" && azurerm_subnet.subnet[k].name != "GatewaySubnet" && azurerm_subnet.subnet[k].name != "AzureFirewallSubnet" && azurerm_subnet.subnet[k].name != "AzureFirewallManagementSubnet"
  }
}