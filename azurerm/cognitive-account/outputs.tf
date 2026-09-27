output "ids" {
  description = "Map of Cognitive Service Account IDs keyed by instance name"
  value       = { for k, v in azurerm_cognitive_account.this : k => v.id }
}

output "names" {
  description = "Map of Cognitive Service Account names keyed by instance name"
  value       = { for k, v in azurerm_cognitive_account.this : k => v.name }
}

output "endpoints" {
  description = "Map of Cognitive Service Account endpoints keyed by instance name"
  value       = { for k, v in azurerm_cognitive_account.this : k => v.endpoint }
}

output "primary_access_keys" {
  description = "Map of primary access keys keyed by instance name"
  value       = { for k, v in azurerm_cognitive_account.this : k => try(v.primary_access_key, null) }
  sensitive   = true
}

output "secondary_access_keys" {
  description = "Map of secondary access keys keyed by instance name"
  value       = { for k, v in azurerm_cognitive_account.this : k => try(v.secondary_access_key, null) }
  sensitive   = true
}

output "principal_ids" {
  description = "Map of managed identity principal IDs keyed by instance name"
  value       = { for k, v in azurerm_cognitive_account.this : k => try(v.identity[0].principal_id, null) }
}

output "tenant_ids" {
  description = "Map of managed identity tenant IDs keyed by instance name"
  value       = { for k, v in azurerm_cognitive_account.this : k => try(v.identity[0].tenant_id, null) }
}
