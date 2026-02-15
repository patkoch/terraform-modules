output "id" {
  description = "The ID of the Deployment for Azure Cognitive Services Account"
  value       = azurerm_cognitive_deployment.this.id
}

output "name" {
  description = "The name of the Cognitive Services Account Deployment"
  value       = azurerm_cognitive_deployment.this.name
}
