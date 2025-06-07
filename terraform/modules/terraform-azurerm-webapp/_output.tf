output "aps_id" {
  description = "The ID of the app service plan"
  value       = azurerm_service_plan.plan.id
}

output "aps_name" {
 description = "The name of the app service plan"
 value       = azurerm_service_plan.plan.name
}

output "webapp_id" {
  description = "The ID of the web application"
  value       = azurerm_linux_web_app.webapp.id
}

output "webapp_name" {
  description = "The name of the web application"
  value       = azurerm_linux_web_app.webapp.name
}