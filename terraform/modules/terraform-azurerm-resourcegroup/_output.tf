output "id" {
  description = "Outputing the id of the resource group"
  value = azurerm_resource_group.rg.id
}

output "name" {
  description = "Outputing the name of the resource group"
  value = azurerm_resource_group.rg.name
}

output "location" {
  description = "Outputing the location of the resource group"
  value = azurerm_resource_group.rg.location
}