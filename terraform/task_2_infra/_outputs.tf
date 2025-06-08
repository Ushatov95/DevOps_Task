output "table_storage_name" {
  description = "The name of the Table Storage"
  value       = azurerm_storage_table.function_table.name
}