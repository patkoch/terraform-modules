# Resource Group Outputs
output "resource_group_id" {
  description = "The ID of the Resource Group"
  value       = module.resource_group.ids["openai"]
}

output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = module.resource_group.names["openai"]
}

output "resource_group_location" {
  description = "The location of the Resource Group"
  value       = module.resource_group.locations["openai"]
}

# Cognitive Account Outputs
output "cognitive_account_id" {
  description = "The ID of the Cognitive Account"
  value       = module.cognitive_account.ids["openai"]
}

output "cognitive_account_endpoint" {
  description = "The endpoint URL of the Cognitive Account"
  value       = module.cognitive_account.endpoints["openai"]
}

output "cognitive_account_primary_key" {
  description = "The primary access key of the Cognitive Account"
  value       = module.cognitive_account.primary_access_keys["openai"]
  sensitive   = true
}

output "cognitive_account_secondary_key" {
  description = "The secondary access key of the Cognitive Account"
  value       = module.cognitive_account.secondary_access_keys["openai"]
  sensitive   = true
}

output "cognitive_account_principal_id" {
  description = "The Principal ID of the Cognitive Account's System Assigned Identity"
  value       = module.cognitive_account.principal_ids["openai"]
}

# Cognitive Deployment Outputs
output "cognitive_deployment_id" {
  description = "The ID of the Cognitive Deployment"
  value       = module.cognitive_deployment.ids["openai"]
}

output "cognitive_deployment_name" {
  description = "The name of the Cognitive Deployment"
  value       = module.cognitive_deployment.names["openai"]
}

# Summary Output
output "openai_service_summary" {
  description = "Summary of the OpenAI Service deployment"
  value = {
    resource_group_name        = module.resource_group.names["openai"]
    resource_group_id          = module.resource_group.ids["openai"]
    resource_group_location    = module.resource_group.locations["openai"]
    cognitive_account_name     = "open-ai-test-west-europe-ca"
    cognitive_account_id       = module.cognitive_account.ids["openai"]
    cognitive_account_endpoint = module.cognitive_account.endpoints["openai"]
    cognitive_account_kind     = "OpenAI"
    cognitive_account_sku      = "S0"
    deployment_name            = module.cognitive_deployment.names["openai"]
    deployment_id              = module.cognitive_deployment.ids["openai"]
    deployment_model_name      = "gpt-4o"
    deployment_model_version   = "2024-11-20"
    deployment_model_format    = "OpenAI"
    deployment_sku_name        = "GlobalStandard"
    deployment_sku_capacity    = 45
  }
}
