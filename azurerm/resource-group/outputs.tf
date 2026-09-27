output "ids" {
  description = "Map of Resource Group IDs keyed by instance name"
  value       = { for k, v in azurerm_resource_group.this : k => v.id }
}

output "names" {
  description = "Map of Resource Group names keyed by instance name"
  value       = { for k, v in azurerm_resource_group.this : k => v.name }
}

output "locations" {
  description = "Map of Resource Group locations keyed by instance name"
  value       = { for k, v in azurerm_resource_group.this : k => v.location }
}
