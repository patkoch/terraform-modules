# Azure Cognitive Services Account Module

This Terraform module creates an Azure Cognitive Services Account. It supports all types of Cognitive Services such as OpenAI, Face Recognition, Speech, Text Analytics, QnA Maker, and many more.

## Features

- Support for all Cognitive Services types (OpenAI, AIServices, Face, Speech, etc.)
- Flexible SKU configuration with validation
- Optional: Managed Identity (SystemAssigned, UserAssigned)
- Optional: Network ACLs for access control
- Optional: Customer Managed Keys for encryption
- Optional: Linked Storage Accounts
- Optional: Network Injection (for AIServices with Agent)
- Configurable timeouts
- Comprehensive input validation

## Usage Examples

### OpenAI Account with Standard SKU

```hcl
module "openai_account" {
  source = "./cognitive-account"

  name                = "myopenai"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  kind                = "OpenAI"
  sku_name            = "S0"

  custom_subdomain_name = "myopenai"

  tags = {
    Environment = "Production"
    Project     = "AI"
  }
}
```

### Face Recognition Account with Managed Identity

```hcl
module "face_account" {
  source = "./cognitive-account"

  name                = "myface"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Face"
  sku_name            = "S0"

  identity = {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}
```

### AIServices Account with Network ACLs

```hcl
module "aiservices_account" {
  source = "./cognitive-account"

  name                = "myaiservices"
  location            = "westus"
  resource_group_name = azurerm_resource_group.example.name
  kind                = "AIServices"
  sku_name            = "S0"

  custom_subdomain_name = "myaiservices"

  network_acls = {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = ["203.0.113.0/24"]
    virtual_network_rules = [
      {
        subnet_id = azurerm_subnet.example.id
      }
    ]
  }

  public_network_access_enabled = false

  tags = {
    Environment = "Production"
    Security    = "Restricted"
  }
}
```

### Speech Account with Customer Managed Key

```hcl
module "speech_account" {
  source = "./cognitive-account"

  name                = "myspeech"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Speech"
  sku_name            = "S0"

  identity = {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }

  customer_managed_key = {
    key_vault_key_id   = azurerm_key_vault_key.example.id
    identity_client_id = azurerm_user_assigned_identity.example.client_id
  }

  tags = {
    Environment = "Production"
    Encryption  = "CMK"
  }
}
```

### TextAnalytics with Custom Question Answering

```hcl
module "textanalytics_account" {
  source = "./cognitive-account"

  name                = "mytextanalytics"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name
  kind                = "TextAnalytics"
  sku_name            = "S"

  custom_question_answering_search_service_id  = azurerm_search_service.example.id
  custom_question_answering_search_service_key = azurerm_search_service.example.primary_key

  tags = {
    Environment = "Production"
  }
}
```

### MetricsAdvisor Account

```hcl
module "metrics_advisor_account" {
  source = "./cognitive-account"

  name                = "mymetricsadvisor"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  kind                = "MetricsAdvisor"
  sku_name            = "S0"

  metrics_advisor_aad_client_id   = "00000000-0000-0000-0000-000000000000"
  metrics_advisor_aad_tenant_id   = "00000000-0000-0000-0000-000000000000"
  metrics_advisor_super_user_name = "admin@example.com"
  metrics_advisor_website_name    = "mymetricsadvisor.cognitiveservices.azure.com"

  tags = {
    Environment = "Production"
  }
}
```

## Requirements

- Terraform >= 1.13
- Azure RM Provider >= 4.60
- An existing Azure Resource Group

## Input Variables

### Required

| Name | Description | Type |
|------|-------------|------|
| `name` | Name of the Cognitive Service Account | `string` |
| `location` | Azure Region | `string` |
| `resource_group_name` | Name of the Resource Group | `string` |
| `kind` | Type of Cognitive Service | `string` |
| `sku_name` | Name of the SKU | `string` |

### Optional - General

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `custom_subdomain_name` | Subdomain for token authentication | `string` | `null` |
| `local_auth_enabled` | Enable local authentication methods | `bool` | `true` |
| `public_network_access_enabled` | Public network access allowed | `bool` | `true` |
| `outbound_network_access_restricted` | Restrict outbound network access | `bool` | `false` |
| `dynamic_throttling_enabled` | Enable dynamic throttling | `bool` | `null` |
| `project_management_enabled` | Enable project management (AIServices only) | `bool` | `false` |
| `fqdns` | List of FQDNs | `list(string)` | `null` |
| `tags` | Tags for the resource | `map(string)` | `{}` |

### Optional - Identity

```hcl
identity = {
  type         = "SystemAssigned"          # or "UserAssigned" or "SystemAssigned, UserAssigned"
  identity_ids = optional(list(string))    # required if type = "UserAssigned"
}
```

### Optional - Network ACLs

```hcl
network_acls = {
  default_action = "Allow"                  # "Allow" or "Deny"
  bypass         = optional("AzureServices") # "None" or "AzureServices"
  ip_rules       = optional(list(string))
  virtual_network_rules = optional(list(object({
    subnet_id                            = string
    ignore_missing_vnet_service_endpoint = optional(bool, false)
  })))
}
```

### Optional - Other Blocks

| Name | Description | Type |
|------|-------------|------|
| `network_injection` | Network injection for Agent (AIServices only) | `object` |
| `customer_managed_key` | Customer Managed Key for encryption at rest | `object` |
| `storage` | Linked Storage Accounts | `list(object)` |

### Optional - MetricsAdvisor Properties

| Name | Description | Type |
|------|-------------|------|
| `metrics_advisor_aad_client_id` | Azure AD Client ID | `string` |
| `metrics_advisor_aad_tenant_id` | Azure AD Tenant ID | `string` |
| `metrics_advisor_super_user_name` | Super User Name | `string` |
| `metrics_advisor_website_name` | Website Name | `string` |

### Optional - TextAnalytics Properties

| Name | Description | Type |
|------|-------------|------|
| `custom_question_answering_search_service_id` | Search Service ID | `string` |
| `custom_question_answering_search_service_key` | Search Service Key | `string` |

### Optional - QnAMaker Properties

| Name | Description | Type |
|------|-------------|------|
| `qna_runtime_endpoint` | QnA Runtime Endpoint URL | `string` |

### Optional - Timeouts

| Name | Default |
|------|---------|
| `timeout_create` | `30m` |
| `timeout_read` | `5m` |
| `timeout_update` | `30m` |
| `timeout_delete` | `30m` |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Cognitive Service Account |
| `name` | Name of the account |
| `endpoint` | Endpoint URL |
| `primary_access_key` | Primary Access Key (sensitive) |
| `secondary_access_key` | Secondary Access Key (sensitive) |
| `identity` | Identity object |
| `principal_id` | Principal ID of the Managed Identity |
| `tenant_id` | Tenant ID of the Managed Identity |

## Valid `kind` Values

- `AIServices` - Azure AI Foundry (comprehensive)
- `OpenAI` - Azure OpenAI Service
- `Face` - Face Recognition
- `ComputerVision` - Computer Vision
- `Speech` - Speech Services
- `SpeechServices` - Speech Services (Alternative)
- `TextAnalytics` - Text Analytics
- `TextTranslation` - Text Translation
- `LUIS` - Language Understanding (LUIS)
- `LUIS.Authoring` - LUIS Authoring
- `QnAMaker` - QnA Maker
- `Personalizer` - Personalizer
- `ContentModerator` - Content Moderator
- `ContentSafety` - Content Safety
- `CustomVision.Training` - Custom Vision Training
- `CustomVision.Prediction` - Custom Vision Prediction
- `AnomalyDetector` - Anomaly Detector
- `FormRecognizer` - Form Recognizer
- `SpeakerRecognition` - Speaker Recognition
- `CustomSpeech` - Custom Speech
- `ImmersiveReader` - Immersive Reader
- `MetricsAdvisor` - Metrics Advisor
- `Bing.Autosuggest` - Bing Autosuggest
- `Bing.Autosuggest.v7` - Bing Autosuggest v7
- `Bing.CustomSearch` - Bing Custom Search
- `Bing.Search` - Bing Search
- `Bing.Search.v7` - Bing Search v7
- `Bing.SpellCheck` - Bing Spell Check
- `Bing.SpellCheck.v7` - Bing Spell Check v7
- `Recommendations` - Recommendations
- `WebLM` - Web Language Model
- `Emotion` - Emotion
- `Academic` - Academic Knowledge
- `CognitiveServices` - Cognitive Services (generic)

## Valid `sku_name` Values

- `F0` - Free
- `F1` - Free (Legacy)
- `S0` - Standard
- `S` - Standard (Alternative)
- `S1` - Standard Tier 1
- `S2` - Standard Tier 2
- `S3` - Standard Tier 3
- `S4` - Standard Tier 4
- `S5` - Standard Tier 5
- `S6` - Standard Tier 6
- `P0` - Premium
- `P1` - Premium Tier 1
- `P2` - Premium Tier 2
- `C2` - Commitment 2
- `C3` - Commitment 3
- `C4` - Commitment 4
- `D3` - Direct
- `E0` - Enterprise
- `DC0` - Disconnected Container

## Important Notes

- **OpenAI & Face/TextAnalytics**: Face, Text Analytics, or Computer Vision accounts must be created via the Azure Portal and terms must be accepted when created in US regions.
- **Bing Search**: New Bing Search resources cannot be created. Existing instances will continue to be supported for 3 more years.
- **Network ACLs**: Require a `custom_subdomain_name`.
- **Customer Managed Keys**: For encryption at rest. Requires a User Assigned Identity.
- **Storage**: Not all `kind` support storage blocks (e.g., OpenAI does not).

## References

- [Terraform Azure RM Provider - Cognitive Account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account)
- [Azure Cognitive Services Documentation](https://learn.microsoft.com/en-us/azure/cognitive-services/)
- [Azure OpenAI Service Documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/)
- [Azure AI Foundry](https://learn.microsoft.com/en-us/azure/ai-foundry/)
