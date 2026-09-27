variable "instances" {
  description = "Map of cognitive accounts to create."
  type = map(object({
    name                                         = string
    location                                     = string
    resource_group_name                          = string
    kind                                         = string
    sku_name                                     = string
    custom_subdomain_name                        = optional(string)
    dynamic_throttling_enabled                   = optional(bool)
    local_auth_enabled                           = optional(bool, false)
    outbound_network_access_restricted           = optional(bool, false)
    public_network_access_enabled                = optional(bool, false)
    project_management_enabled                   = optional(bool, false)
    fqdns                                        = optional(list(string))
    metrics_advisor_aad_client_id                = optional(string)
    metrics_advisor_aad_tenant_id                = optional(string)
    metrics_advisor_super_user_name              = optional(string)
    metrics_advisor_website_name                 = optional(string)
    qna_runtime_endpoint                         = optional(string)
    custom_question_answering_search_service_id  = optional(string)
    custom_question_answering_search_service_key = optional(string)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    network_acls = optional(object({
      default_action = string
      bypass         = optional(string)
      ip_rules       = optional(list(string))
      virtual_network_rules = optional(list(object({
        subnet_id                            = string
        ignore_missing_vnet_service_endpoint = optional(bool, false)
      })))
    }))
    network_injection = optional(object({
      scenario  = string
      subnet_id = string
    }))
    customer_managed_key = optional(object({
      key_vault_key_id   = string
      identity_client_id = optional(string)
    }))
    storage = optional(list(object({
      storage_account_id = string
      identity_client_id = optional(string)
    })))
    tags           = optional(map(string), {})
    timeout_create = optional(string, "30m")
    timeout_read   = optional(string, "5m")
    timeout_update = optional(string, "30m")
    timeout_delete = optional(string, "30m")
  }))
  default = {}

  validation {
    condition = alltrue([
      for _, v in var.instances : contains([
        "Academic", "AIServices", "AnomalyDetector", "Bing.Autosuggest", "Bing.Autosuggest.v7",
        "Bing.CustomSearch", "Bing.Search", "Bing.Search.v7", "Bing.Speech", "Bing.SpellCheck",
        "Bing.SpellCheck.v7", "CognitiveServices", "ComputerVision", "ContentModerator", "ContentSafety",
        "CustomSpeech", "CustomVision.Prediction", "CustomVision.Training", "Emotion", "Face",
        "FormRecognizer", "ImmersiveReader", "LUIS", "LUIS.Authoring", "MetricsAdvisor", "OpenAI",
        "Personalizer", "QnAMaker", "Recommendations", "SpeakerRecognition", "Speech", "SpeechServices",
        "SpeechTranslation", "TextAnalytics", "TextTranslation", "WebLM"
      ], v.kind)
    ])
    error_message = "Each cognitive account kind must be a valid Azure Cognitive Services kind."
  }

  validation {
    condition = alltrue([
      for _, v in var.instances : contains(["C2", "C3", "C4", "D3", "DC0", "E0", "F0", "F1", "P0", "P1", "P2", "S", "S0", "S1", "S2", "S3", "S4", "S5", "S6"], v.sku_name)
    ])
    error_message = "Each cognitive account sku_name must be a valid Azure Cognitive Services SKU."
  }
}
