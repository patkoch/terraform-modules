mock_provider "azurerm" {}

# Happy Path 1: Minimal valid configuration with a single instance
run "happy_path_minimal" {
  command = plan

  variables {
    instances = {
      rg_primary = {
        name     = "my-resource-group"
        location = "West Europe"
      }
    }
  }

  assert {
    condition     = azurerm_resource_group.this["rg_primary"].name == "my-resource-group"
    error_message = "Resource group name should be 'my-resource-group'."
  }

  assert {
    condition     = azurerm_resource_group.this["rg_primary"].location == "West Europe"
    error_message = "Resource group location should be 'West Europe'."
  }
}

# Happy Path 2: Multiple instances with tags
run "happy_path_multiple_instances" {
  command = plan

  variables {
    instances = {
      rg_prod = {
        name     = "rg-production-001"
        location = "East US"
        tags = {
          Environment = "Production"
          ManagedBy   = "Terraform"
          Project     = "MyProject"
        }
      }
      rg_dev = {
        name     = "rg-development-001"
        location = "West Europe"
      }
    }
  }

  assert {
    condition     = length(azurerm_resource_group.this) == 2
    error_message = "Exactly two resource groups should be planned."
  }

  assert {
    condition     = azurerm_resource_group.this["rg_prod"].tags["Environment"] == "Production"
    error_message = "Tag 'Environment' should be 'Production'."
  }
}

# Non-Happy Path: Invalid name containing disallowed characters
run "non_happy_path_invalid_name" {
  command = plan

  variables {
    instances = {
      bad_rg = {
        name     = "invalid name with spaces!"
        location = "West Europe"
      }
    }
  }

  expect_failures = [var.instances]
}
