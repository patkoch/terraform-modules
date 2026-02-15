output "id" {
  description = "The ID of the Cognitive Service Account"
  value       = azurerm_cognitive_account.this.id
}

output "name" {
  description = "The name of the Cognitive Service Account"
  value       = azurerm_cognitive_account.this.name
}

output "endpoint" {
  description = "The endpoint used to connect to the Cognitive Service Account"
  value       = azurerm_cognitive_account.this.endpoint
}

output "primary_access_key" {
  description = "The primary access key for the Cognitive Service Account"
  value       = try(azurerm_cognitive_account.this.primary_access_key, null)
  sensitive   = true
}

output "secondary_access_key" {
  description = "The secondary access key for the Cognitive Service Account"
  value       = try(azurerm_cognitive_account.this.secondary_access_key, null)
  sensitive   = true
}

output "identity" {
  description = "The identity details of the Cognitive Service Account"
  value       = try(azurerm_cognitive_account.this.identity, null)
}

output "principal_id" {
  description = "The Principal ID associated with this Managed Service Identity"
  value       = try(azurerm_cognitive_account.this.identity[0].principal_id, null)
}

output "tenant_id" {
  description = "The Tenant ID associated with this Managed Service Identity"
  value       = try(azurerm_cognitive_account.this.identity[0].tenant_id, null)
}
