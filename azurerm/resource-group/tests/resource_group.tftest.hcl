mock_provider "azurerm" {}

# Happy Path 1: Minimal valid configuration
run "happy_path_minimal" {
  command = plan

  variables {
    name     = "my-resource-group"
    location = "West Europe"
  }

  assert {
    condition     = azurerm_resource_group.this.name == "my-resource-group"
    error_message = "Resource group name should be 'my-resource-group'."
  }

  assert {
    condition     = azurerm_resource_group.this.location == "West Europe"
    error_message = "Resource group location should be 'West Europe'."
  }
}

# Happy Path 2: Valid configuration with tags
run "happy_path_with_tags" {
  command = plan

  variables {
    name     = "rg-production-001"
    location = "East US"
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      Project     = "MyProject"
    }
  }

  assert {
    condition     = azurerm_resource_group.this.name == "rg-production-001"
    error_message = "Resource group name should be 'rg-production-001'."
  }

  assert {
    condition     = azurerm_resource_group.this.tags["Environment"] == "Production"
    error_message = "Tag 'Environment' should be 'Production'."
  }
}

# Non-Happy Path: Invalid name containing disallowed characters
run "non_happy_path_invalid_name" {
  command = plan

  variables {
    name     = "invalid name with spaces!"
    location = "West Europe"
  }

  expect_failures = [var.name]
}
