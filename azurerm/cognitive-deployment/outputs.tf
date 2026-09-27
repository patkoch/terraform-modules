output "ids" {
  description = "Map of Cognitive Service Deployment IDs keyed by instance name"
  value       = { for k, v in azurerm_cognitive_deployment.this : k => v.id }
}

output "names" {
  description = "Map of Cognitive Service Deployment names keyed by instance name"
  value       = { for k, v in azurerm_cognitive_deployment.this : k => v.name }
}
