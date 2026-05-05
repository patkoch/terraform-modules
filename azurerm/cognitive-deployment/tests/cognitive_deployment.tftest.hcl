mock_provider "azurerm" {}

# Happy Path 1: Minimal valid cognitive deployment configuration
run "happy_path_minimal" {
  command = plan

  variables {
    deployment_name      = "gpt-4o-deployment"
    cognitive_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.CognitiveServices/accounts/my-openai"
    model_format         = "OpenAI"
    model_name           = "gpt-4o"
    sku_name             = "GlobalStandard"
  }

  assert {
    condition     = azurerm_cognitive_deployment.this.name == "gpt-4o-deployment"
    error_message = "Deployment name should be 'gpt-4o-deployment'."
  }

  assert {
    condition     = azurerm_cognitive_deployment.this.model[0].format == "OpenAI"
    error_message = "Model format should be 'OpenAI'."
  }

  assert {
    condition     = azurerm_cognitive_deployment.this.model[0].name == "gpt-4o"
    error_message = "Model name should be 'gpt-4o'."
  }
}

# Happy Path 2: Full configuration with version, capacity and upgrade option
run "happy_path_with_version_and_capacity" {
  command = plan

  variables {
    deployment_name        = "gpt-4o-deployment-v2"
    cognitive_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.CognitiveServices/accounts/my-openai"
    model_format           = "OpenAI"
    model_name             = "gpt-4o"
    model_version          = "2024-11-20"
    sku_name               = "GlobalStandard"
    sku_capacity           = 45
    version_upgrade_option = "NoAutoUpgrade"
  }

  assert {
    condition     = azurerm_cognitive_deployment.this.name == "gpt-4o-deployment-v2"
    error_message = "Deployment name should be 'gpt-4o-deployment-v2'."
  }

  assert {
    condition     = azurerm_cognitive_deployment.this.version_upgrade_option == "NoAutoUpgrade"
    error_message = "version_upgrade_option should be 'NoAutoUpgrade'."
  }

  assert {
    condition     = azurerm_cognitive_deployment.this.sku[0].capacity == 45
    error_message = "SKU capacity should be 45."
  }
}

# Non-Happy Path: Invalid version_upgrade_option value
run "non_happy_path_invalid_version_upgrade_option" {
  command = plan

  variables {
    deployment_name        = "gpt-4o-deployment"
    cognitive_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.CognitiveServices/accounts/my-openai"
    model_format           = "OpenAI"
    model_name             = "gpt-4o"
    sku_name               = "GlobalStandard"
    version_upgrade_option = "InvalidOption"
  }

  expect_failures = [var.version_upgrade_option]
}
