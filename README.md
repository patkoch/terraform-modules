# Terraform Azure Modules

A collection of production-ready Terraform modules for deploying and managing Azure resources, with a focus on Azure AI Services and Cognitive Services.

## Overview

This repository contains reusable Terraform modules for Azure infrastructure deployment. All modules follow Terraform best practices, include comprehensive validation, and are designed to be composable and easy to use.

## Repository Structure

```
terraform-modules/
├── azurerm/
│   ├── resource-group/              # Azure Resource Group module
│   ├── cognitive-account/           # Azure Cognitive Services Account module
│   ├── cognitive-deployment/        # Azure Cognitive Deployment module
│   ├── openai-deployment/           # Complete OpenAI deployment example
│   └── examples/
│       └── cognitive-openai/        # Comprehensive OpenAI deployment example
└── README.md                        # This file
```

## Available Modules

### 1. Resource Group Module (`azurerm/resource-group`)

Create and manage Azure Resource Groups - the logical container for all Azure resources.

**Features:**
- Name and location validation
- Flexible tag management
- Lifecycle management for tags

**Key Variables:**
- `name` - Resource group name (required)
- `location` - Azure region (required)
- `tags` - Resource tags (optional)

**Resources Created:**
- `azurerm_resource_group`

**Documentation:** [Resource Group README](azurerm/resource-group/README.md)

---

### 2. Cognitive Account Module (`azurerm/cognitive-account`)

Deploy Azure Cognitive Services Accounts supporting all service types including OpenAI, Face Recognition, Speech, Text Analytics, QnA Maker, and more.

**Features:**
- Support for 26+ Cognitive Service types
- Flexible SKU configuration with validation
- Managed Identity support (SystemAssigned, UserAssigned)
- Network ACLs for access control
- Customer Managed Keys for encryption at rest
- Linked Storage Accounts support
- Network Injection for AIServices
- Service-specific properties (MetricsAdvisor, QnAMaker, TextAnalytics)

**Key Variables:**
- `name` - Account name with hyphen support (required)
- `location` - Azure region (required)
- `resource_group_name` - Resource group name (required)
- `kind` - Cognitive Service type (required)
- `sku_name` - SKU name (required)
- `custom_subdomain_name` - Custom subdomain for authentication (optional)
- `identity` - Managed Identity configuration (optional)
- `network_acls` - Network access control (optional)
- `tags` - Resource tags (optional)

**Supported Service Types:**
- OpenAI
- AIServices
- Face
- ComputerVision
- Speech / SpeechServices
- TextAnalytics
- TextTranslation
- LUIS / LUIS.Authoring
- QnAMaker
- Personalizer
- ContentModerator
- ContentSafety
- CustomVision.Training / CustomVision.Prediction
- And more...

**Resources Created:**
- `azurerm_cognitive_account`

**Documentation:** [Cognitive Account README](azurerm/cognitive-account/README.md)

---

### 3. Cognitive Deployment Module (`azurerm/cognitive-deployment`)

Deploy AI models to Cognitive Services Accounts supporting OpenAI, Cohere, AI21Labs, Meta, Mistral AI, and other model providers.

**Features:**
- Support for various model formats (OpenAI, Cohere, AI21Labs, Meta, Mistral, etc.)
- Multiple SKU options (Standard, ProvisionedManaged, GlobalStandard, etc.)
- Flexible capacity configuration (Tokens-per-Minute)
- Dynamic throttling support
- RAI (Responsible AI) Policy support
- Automatic version upgrade options
- Configurable timeouts

**Key Variables:**
- `deployment_name` - Name of the deployment (required)
- `cognitive_account_id` - ID of the Cognitive Account (required)
- `model_format` - Model format/provider (required)
- `model_name` - Model name (required)
- `model_version` - Model version (optional)
- `sku_name` - SKU name (required)
- `sku_capacity` - Tokens per minute capacity (optional)
- `version_upgrade_option` - Auto-upgrade strategy (optional)

**Model Formats Supported:**
- OpenAI (GPT-4, GPT-4o, GPT-3.5, etc.)
- Cohere
- AI21Labs
- Meta (Llama)
- Mistral AI
- And others by region

**Resources Created:**
- `azurerm_cognitive_deployment`

**Documentation:** [Cognitive Deployment README](azurerm/cognitive-deployment/README.md)

---

## Quick Start Examples

### Deploy an OpenAI Service

```bash
cd azurerm/openai-deployment
terraform init
terraform plan
terraform apply
```

This will create:
1. Resource Group in West Europe
2. OpenAI Cognitive Account with S0 SKU
3. GPT-4o Deployment with GlobalStandard SKU and 45 TCU capacity

### Use the Modules Individually

```hcl
# Create a resource group
module "rg" {
  source = "./azurerm/resource-group"
  
  name     = "my-resources"
  location = "eastus"
  
  tags = {
    Environment = "Production"
    Project     = "MyProject"
  }
}

# Create a Cognitive Account
module "cognitive_account" {
  source = "./azurerm/cognitive-account"
  
  name                = "my-openai"
  location            = module.rg.location
  resource_group_name = module.rg.name
  kind                = "OpenAI"
  sku_name            = "S0"
  
  custom_subdomain_name = "my-openai"
  
  identity = {
    type = "SystemAssigned"
  }
}

# Deploy a model
module "deployment" {
  source = "./azurerm/cognitive-deployment"
  
  deployment_name      = "gpt4-deployment"
  cognitive_account_id = module.cognitive_account.id
  
  model_format  = "OpenAI"
  model_name    = "gpt-4o"
  model_version = "2024-11-20"
  
  sku_name     = "GlobalStandard"
  sku_capacity = 45
}
```

## Requirements

All modules require:

- **Terraform:** >= 1.13
- **AWS RM Provider:** >= 4.60
- **Azure Authentication:** Configured via Azure CLI or Service Principal

### Install Azure CLI

```bash
# macOS
brew install azure-cli

# Windows (PowerShell)
choco install azure-cli

# Linux
# See https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
```

### Authenticate with Azure

```bash
az login
```

## Module Features

### Input Validation

All modules include comprehensive input validation with specific error messages:

```hcl
# Example: cognitive-account name validation
validation {
  condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{0,62}[a-zA-Z0-9]$|^[a-zA-Z0-9]$", var.name))
  error_message = "The name must be between 2 and 64 characters and contain only alphanumeric characters and hyphens."
}
```

### Configurable Timeouts

All modules support customizable timeouts:

```hcl
timeout_create = "30m"  # Default
timeout_read   = "5m"   # Default
timeout_update = "30m"  # Default
timeout_delete = "30m"  # Default
```

### Comprehensive Outputs

All modules provide detailed outputs for integration with other configurations:

```hcl
# Example outputs from cognitive-account
output "id" {}                    # Account ID
output "endpoint" {}              # API Endpoint
output "primary_access_key" {}    # API Key (sensitive)
output "secondary_access_key" {}  # Secondary Key (sensitive)
```

## Best Practices

### 1. Remote State

Use Azure Storage for remote Terraform state:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state"
    storage_account_name = "tfstate"
    container_name       = "tfstate"
    key                  = "prod.tfstate"
  }
}
```

### 2. Sensitive Values

Protect sensitive outputs:

```bash
# Export API keys as environment variables
export OPENAI_API_KEY=$(terraform output -raw cognitive_account_primary_key)
```

### 3. Tagging Strategy

Follow consistent tagging conventions:

```hcl
tags = {
  Environment = "Production"
  Project     = "ProjectName"
  Owner       = "TeamName"
  CostCenter  = "12345"
  ManagedBy   = "Terraform"
}
```

### 4. Module Composition

Combine modules for complex deployments:

```hcl
module "infrastructure" {
  source = "./azurerm/openai-deployment"
  # All dependencies are automatically managed
}
```

## Troubleshooting

### Common Issues

**Issue: "Invalid value for variable"**
- Check variable naming rules in the module documentation
- Verify all required variables are provided

**Issue: "Location is not available"**
- Verify the service is available in your selected region
- Check Microsoft Azure documentation for service availability

**Issue: "Capacity not available"**
- The requested capacity might not be available in your region
- Try a different SKU or region

**Issue: "Custom Subdomain is already taken"**
- Subdomains must be globally unique
- Use a unique subdomain name

### Enable Debug Logging

```bash
export TF_LOG=DEBUG
terraform apply
```

## Documentation

All modules include detailed README files:

- [Resource Group Module](azurerm/resource-group/README.md)
- [Cognitive Account Module](azurerm/cognitive-account/README.md)
- [Cognitive Deployment Module](azurerm/cognitive-deployment/README.md)
- [OpenAI Deployment Example](azurerm/examples/cognitive-openai/README.md)

## Contributing

To add new modules or improve existing ones:

1. Follow the module structure (main.tf, variables.tf, outputs.tf, versions.tf, README.md)
2. Include comprehensive input validation
3. Add detailed comments and documentation
4. Test the module thoroughly
5. Update this README with the new module

## Version Compatibility

- Terraform 1.13 or higher
- Azure Provider 4.60 or higher
- Tested with latest Azure API versions (2025-06-01 for Cognitive Services)

## Security Considerations

- Never commit `terraform.tfstate` files to version control
- Use `.gitignore` to exclude state files
- Store sensitive values in Azure Key Vault
- Enable Customer Managed Keys for encryption at rest
- Use Managed Identities instead of API keys when possible
- Restrict network access using Network ACLs

## License

These modules are provided as-is for use with Azure deployments.

## Support

For issues or questions:

1. Review the module-specific README files
2. Check Azure documentation
3. Consult Terraform Azure Provider documentation
4. Enable debug logging with `TF_LOG=DEBUG`

## Resources

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Cognitive Services Documentation](https://learn.microsoft.com/en-us/azure/cognitive-services/)
- [Azure OpenAI Service Documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/)
- [Azure AI Foundry](https://learn.microsoft.com/en-us/azure/ai-foundry/)
- [Terraform Best Practices](https://www.terraform.io/docs/glossary#best-practices)