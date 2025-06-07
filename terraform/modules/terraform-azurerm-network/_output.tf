output "subnets" {
  description = "Outputing the subnets of the virtual network"
  value = azurerm_subnet.subnet
}

output "vnet" {
  description = "Outputing the virtual network"
  value = azurerm_virtual_network.vnet
}

output "vnet_id" {
  description = "Outputing the id of the virtual network"
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Outputing the name of the virtual network"
  value = azurerm_virtual_network.vnet.name
}