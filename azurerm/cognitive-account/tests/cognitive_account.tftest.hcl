mock_provider "azurerm" {}

# Happy Path 1: Minimal valid OpenAI cognitive account configuration
run "happy_path_openai_minimal" {
  command = plan

  variables {
    name                = "openai-account-01"
    location            = "West Europe"
    resource_group_name = "my-resource-group"
    kind                = "OpenAI"
    sku_name            = "S0"
  }

  assert {
    condition     = azurerm_cognitive_account.this.name == "openai-account-01"
    error_message = "Cognitive account name should be 'openai-account-01'."
  }

  assert {
    condition     = azurerm_cognitive_account.this.kind == "OpenAI"
    error_message = "Cognitive account kind should be 'OpenAI'."
  }

  assert {
    condition     = azurerm_cognitive_account.this.sku_name == "S0"
    error_message = "Cognitive account SKU name should be 'S0'."
  }

  assert {
    condition     = azurerm_cognitive_account.this.local_auth_enabled == false
    error_message = "local_auth_enabled should default to false."
  }

  assert {
    condition     = azurerm_cognitive_account.this.public_network_access_enabled == false
    error_message = "public_network_access_enabled should default to false."
  }
}

# Happy Path 2: Valid configuration with SystemAssigned identity and custom subdomain
run "happy_path_with_identity" {
  command = plan

  variables {
    name                  = "openai-account-02"
    location              = "North Europe"
    resource_group_name   = "my-resource-group"
    kind                  = "OpenAI"
    sku_name              = "S0"
    custom_subdomain_name = "my-openai-subdomain"
    local_auth_enabled    = false
    identity = {
      type = "SystemAssigned"
    }
    tags = {
      Environment = "Test"
      ManagedBy   = "Terraform"
    }
  }

  assert {
    condition     = azurerm_cognitive_account.this.name == "openai-account-02"
    error_message = "Cognitive account name should be 'openai-account-02'."
  }

  assert {
    condition     = azurerm_cognitive_account.this.custom_subdomain_name == "my-openai-subdomain"
    error_message = "Custom subdomain name should be 'my-openai-subdomain'."
  }

  assert {
    condition     = azurerm_cognitive_account.this.local_auth_enabled == false
    error_message = "local_auth_enabled should be false."
  }

  assert {
    condition     = azurerm_cognitive_account.this.public_network_access_enabled == false
    error_message = "public_network_access_enabled should be false."
  }
}

# Non-Happy Path: Invalid kind value
run "non_happy_path_invalid_kind" {
  command = plan

  variables {
    name                = "openai-account-03"
    location            = "West Europe"
    resource_group_name = "my-resource-group"
    kind                = "InvalidKind"
    sku_name            = "S0"
  }

  expect_failures = [var.kind]
}
