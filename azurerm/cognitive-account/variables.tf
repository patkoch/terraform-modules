variable "name" {
  description = "The name of the Cognitive Service Account"
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{0,62}[a-zA-Z0-9]$|^[a-zA-Z0-9]$", var.name))
    error_message = "The name must be between 2 and 64 characters and contain only alphanumeric characters and hyphens. It must start and end with an alphanumeric character."
  }
}

variable "location" {
  description = "The Azure region where the Cognitive Service Account should be created"
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Cognitive Service Account should be created"
  type        = string
  nullable    = false
}

variable "kind" {
  description = "The kind of Cognitive Service Account that should be created"
  type        = string
  nullable    = false

  validation {
    condition = contains([
      "Academic", "AIServices", "AnomalyDetector", "Bing.Autosuggest", "Bing.Autosuggest.v7",
      "Bing.CustomSearch", "Bing.Search", "Bing.Search.v7", "Bing.Speech", "Bing.SpellCheck",
      "Bing.SpellCheck.v7", "CognitiveServices", "ComputerVision", "ContentModerator", "ContentSafety",
      "CustomSpeech", "CustomVision.Prediction", "CustomVision.Training", "Emotion", "Face",
      "FormRecognizer", "ImmersiveReader", "LUIS", "LUIS.Authoring", "MetricsAdvisor", "OpenAI",
      "Personalizer", "QnAMaker", "Recommendations", "SpeakerRecognition", "Speech", "SpeechServices",
      "SpeechTranslation", "TextAnalytics", "TextTranslation", "WebLM"
    ], var.kind)
    error_message = "The kind value is not valid. Please refer to the documentation for the list of valid kinds."
  }
}

variable "sku_name" {
  description = "The SKU name for the Cognitive Service Account"
  type        = string
  nullable    = false

  validation {
    condition     = contains(["C2", "C3", "C4", "D3", "DC0", "E0", "F0", "F1", "P0", "P1", "P2", "S", "S0", "S1", "S2", "S3", "S4", "S5", "S6"], var.sku_name)
    error_message = "The sku_name value must be one of: C2, C3, C4, D3, DC0, E0, F0, F1, P0, P1, P2, S, S0, S1, S2, S3, S4, S5, S6."
  }
}

variable "custom_subdomain_name" {
  description = "The subdomain name used for Entra ID token-based authentication. Required for OpenAI and when using network_acls"
  type        = string
  default     = null
}

variable "dynamic_throttling_enabled" {
  description = "Whether to enable dynamic throttling for this Cognitive Service Account. Cannot be set when kind is OpenAI or AIServices"
  type        = bool
  default     = null
}

variable "local_auth_enabled" {
  description = "Whether local authentication methods is enabled for the Cognitive Account"
  type        = bool
  default     = true
}

variable "outbound_network_access_restricted" {
  description = "Whether outbound network access is restricted for the Cognitive Account"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed for the Cognitive Account"
  type        = bool
  default     = true
}

variable "project_management_enabled" {
  description = "Whether project management is enabled. Can only be set when kind is AIServices"
  type        = bool
  default     = false
}

variable "fqdns" {
  description = "List of FQDNs allowed for the Cognitive Account"
  type        = list(string)
  default     = null
}

variable "metrics_advisor_aad_client_id" {
  description = "The Azure AD Client ID (Application ID). Only set when kind is MetricsAdvisor"
  type        = string
  default     = null
}

variable "metrics_advisor_aad_tenant_id" {
  description = "The Azure AD Tenant ID. Only set when kind is MetricsAdvisor"
  type        = string
  default     = null
}

variable "metrics_advisor_super_user_name" {
  description = "The super user of Metrics Advisor. Only set when kind is MetricsAdvisor"
  type        = string
  default     = null
}

variable "metrics_advisor_website_name" {
  description = "The website name of Metrics Advisor. Mandatory if kind is QnAMaker"
  type        = string
  default     = null
}

variable "qna_runtime_endpoint" {
  description = "A URL to link a QnAMaker cognitive account to a QnA runtime"
  type        = string
  default     = null
}

variable "custom_question_answering_search_service_id" {
  description = "If kind is TextAnalytics this specifies the ID of the Search service"
  type        = string
  default     = null
}

variable "custom_question_answering_search_service_key" {
  description = "If kind is TextAnalytics this specifies the key of the Search service"
  type        = string
  default     = null
  sensitive   = true
}

variable "identity" {
  description = "An identity block with type and identity_ids"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null

  validation {
    condition = var.identity == null || contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity.type)
    error_message = "Identity type must be one of: SystemAssigned, UserAssigned, or 'SystemAssigned, UserAssigned'."
  }
}

variable "network_acls" {
  description = "A network_acls block for restricting network access"
  type = object({
    default_action = string
    bypass         = optional(string)
    ip_rules       = optional(list(string))
    virtual_network_rules = optional(list(object({
      subnet_id                            = string
      ignore_missing_vnet_service_endpoint = optional(bool, false)
    })))
  })
  default = null

  validation {
    condition = var.network_acls == null || contains(["Allow", "Deny"], var.network_acls.default_action)
    error_message = "default_action must be either Allow or Deny."
  }

  validation {
    condition = var.network_acls == null || var.network_acls.bypass == null || contains(["None", "AzureServices"], var.network_acls.bypass)
    error_message = "bypass must be either None or AzureServices."
  }
}

variable "network_injection" {
  description = "A network_injection block for agent network injection"
  type = object({
    scenario  = string
    subnet_id = string
  })
  default = null

  validation {
    condition = var.network_injection == null || var.network_injection.scenario == "agent"
    error_message = "scenario must be 'agent'."
  }
}

variable "customer_managed_key" {
  description = "A customer_managed_key block for encryption at rest"
  type = object({
    key_vault_key_id   = string
    identity_client_id = optional(string)
  })
  default = null
}

variable "storage" {
  description = "A list of storage blocks for linked storage accounts"
  type = list(object({
    storage_account_id = string
    identity_client_id = optional(string)
  }))
  default = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "timeout_create" {
  description = "Timeout for creating the Cognitive Service Account"
  type        = string
  default     = "30m"
}

variable "timeout_read" {
  description = "Timeout for reading the Cognitive Service Account"
  type        = string
  default     = "5m"
}

variable "timeout_update" {
  description = "Timeout for updating the Cognitive Service Account"
  type        = string
  default     = "30m"
}

variable "timeout_delete" {
  description = "Timeout for deleting the Cognitive Service Account"
  type        = string
  default     = "30m"
}
