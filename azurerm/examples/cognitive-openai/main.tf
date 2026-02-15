# Resource Group
module "resource_group" {
  source = "../../resource-group"

  name     = "open-ai-test-west-europe-rg"
  location = "West Europe"

  tags = {
    Project     = "OpenAI-Test"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

# Cognitive Account (OpenAI)
module "cognitive_account" {
  source = "../../cognitive-account"

  name                = "open-ai-test-west-europe-ca"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  kind                = "OpenAI"
  sku_name            = "S0"

  custom_subdomain_name = "open-ai-test-west-europe"

  # Enable System Assigned Identity for better security
  identity = {
    type = "SystemAssigned"
  }

  tags = {
    Project     = "OpenAI-Test"
    Environment = "Test"
    Service     = "OpenAI"
  }

  depends_on = [module.resource_group]
}

# Cognitive Deployment (GPT-4o Model)
module "cognitive_deployment" {
  source = "../../cognitive-deployment"

  deployment_name      = "open-ai-test-west-europe-cd"
  cognitive_account_id = module.cognitive_account.id

  model_format  = "OpenAI"
  model_name    = "gpt-4o"
  model_version = "2024-11-20"

  sku_name     = "GlobalStandard"
  sku_capacity = 45

  version_upgrade_option = "OnceNewDefaultVersionAvailable"

  depends_on = [module.cognitive_account]
}
