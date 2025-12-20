output "rg_ids" {
  description = "Map of resource group ids"
  value       = { for k, v in azurerm_resource_group.rgs : k => v.id }
}

output "rg_locations" {
  description = "Map of resource group locations"
  value       = { for k, v in azurerm_resource_group.rgs : k => v.location }
}
output "location" {
  description = "Resource group location"
  value       = azurerm_resource_group.this.location
}
