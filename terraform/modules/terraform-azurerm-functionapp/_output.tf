output "aps_id" {
  description = "The ID of the app service plan"
  value       = azurerm_service_plan.plan.id
}

output "aps_name" {
 description = "The name of the app service plan"
 value       = azurerm_service_plan.plan.name
}

output "funapp_id" {
  description = "The ID of the web application"
  value       = azurerm_linux_function_app.func_table_writer.id
}

output "funapp_name" {
  description = "The name of the web application"
  value       = azurerm_linux_function_app.func_table_writer.name
}