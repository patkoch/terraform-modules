# Azure Cognitive Services Deployment Module

This Terraform module creates an Azure Cognitive Services Account Deployment. It supports various models (e.g., OpenAI, Cohere, AI21Labs) with flexible SKU options.

## Features

- Deployment of various AI models (OpenAI, Cohere, AI21Labs, etc.)
- Flexible SKU configuration (Standard, ProvisionedManaged, etc.)
- Support for Capacity (Tokens-per-Minute)
- Optional: Dynamic Throttling and RAI Policy
- Configurable timeouts

## Usage Examples

### OpenAI GPT-4 Deployment

```hcl
module "cognitive_deployment" {
  source = "./cognitive-deployment"

  deployment_name      = "gpt4-deployment"
  cognitive_account_id = azurerm_cognitive_account.example.id

  model_format = "OpenAI"
  model_name   = "gpt-4"
  model_version = "1106-preview"

  sku_name     = "Standard"
  sku_capacity = 10  # 10,000 tokens per minute
}
```

### OpenAI Text Curie Deployment

```hcl
module "cognitive_deployment" {
  source = "./cognitive-deployment"

  deployment_name      = "curie-deployment"
  cognitive_account_id = azurerm_cognitive_account.example.id

  model_format = "OpenAI"
  model_name   = "text-curie-001"
  model_version = "1"

  sku_name = "Standard"
}
```

### ProvisionedManaged Deployment with RAI Policy

```hcl
module "cognitive_deployment" {
  source = "./cognitive-deployment"

  deployment_name      = "provisioned-deployment"
  cognitive_account_id = azurerm_cognitive_account.example.id

  model_format = "OpenAI"
  model_name   = "gpt-4"

  sku_name     = "ProvisionedManaged"
  sku_capacity = 100

  rai_policy_name        = "my-rai-policy"
  dynamic_throttling_enabled = true
  version_upgrade_option = "OnceNewDefaultVersionAvailable"
}
```

## Requirements

- Terraform >= 1.0
- Azure RM Provider >= 3.0
- An existing Cognitive Services Account in Azure

## Input Variables

### Required

| Name | Description | Type |
|------|-------------|------|
| `deployment_name` | Name of the deployment | `string` |
| `cognitive_account_id` | ID of the Cognitive Services Account | `string` |
| `model_format` | Format of the model (e.g., OpenAI, Cohere, AI21Labs) | `string` |
| `model_name` | Name of the model (e.g., gpt-4, text-curie-001) | `string` |
| `sku_name` | Name of the SKU (e.g., Standard, ProvisionedManaged) | `string` |

### Optional

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `model_version` | Version of the model | `string` | `null` |
| `sku_tier` | Tier of the SKU (Free, Basic, Standard, Premium, Enterprise) | `string` | `null` |
| `sku_size` | Size of the SKU | `string` | `null` |
| `sku_family` | Hardware family | `string` | `null` |
| `sku_capacity` | Tokens-per-Minute in thousands | `number` | `null` |
| `dynamic_throttling_enabled` | Enable dynamic throttling | `bool` | `null` |
| `rai_policy_name` | Name of the RAI Policy | `string` | `null` |
| `version_upgrade_option` | Version upgrade option | `string` | `"OnceNewDefaultVersionAvailable"` |
| `timeout_create` | Timeout for create operation | `string` | `"30m"` |
| `timeout_read` | Timeout for read operation | `string` | `"5m"` |
| `timeout_update` | Timeout for update operation | `string` | `"30m"` |
| `timeout_delete` | Timeout for delete operation | `string` | `"30m"` |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the deployment |
| `name` | The name of the deployment |

## Valid SKU Names

- `Standard` - Standard Pay-as-you-go
- `DataZoneBatch` - Data Zone Batch Processing
- `DataZoneStandard` - Data Zone Standard
- `DataZoneProvisionedManaged` - Data Zone Provisioned Managed
- `GlobalBatch` - Global Batch Processing
- `GlobalProvisionedManaged` - Global Provisioned Managed
- `GlobalStandard` - Global Standard
- `ProvisionedManaged` - Provisioned Managed (with capacity)

## Valid Model Formats

- `OpenAI` - OpenAI models (GPT-4, GPT-3.5, etc.)
- `Cohere` - Cohere models
- `AI21Labs` - AI21 Labs models
- `Meta` - Meta models (Llama, etc.)
- `Mistral AI` - Mistral AI models
- And others depending on region and availability

## Version Upgrade Options

- `OnceNewDefaultVersionAvailable` (default) - Upgrade to new default version
- `OnceCurrentVersionExpired` - Upgrade only when current version expires
- `NoAutoUpgrade` - No automatic upgrade

## References

- [Terraform Azure RM Provider - Cognitive Deployment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_deployment)
- [Azure Cognitive Services Documentation](https://learn.microsoft.com/en-us/azure/cognitive-services/)
- [Azure OpenAI Service Documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/)
