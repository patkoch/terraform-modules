variable "deployment_name" {
  description = "The name of the Cognitive Services Account Deployment"
  type        = string
  nullable    = false
}

variable "cognitive_account_id" {
  description = "The ID of the Cognitive Services Account"
  type        = string
  nullable    = false
}

variable "model_format" {
  description = "The format of the Cognitive Services Account Deployment model (e.g., OpenAI, Cohere, AI21Labs)"
  type        = string
  nullable    = false
}

variable "model_name" {
  description = "The name of the Cognitive Services Account Deployment model (e.g., text-curie-001, text-davinci-003)"
  type        = string
  nullable    = false
}

variable "model_version" {
  description = "The version of Cognitive Services Account Deployment model"
  type        = string
  default     = null
}

variable "sku_name" {
  description = "The name of the SKU. Valid values include Standard, DataZoneBatch, DataZoneStandard, DataZoneProvisionedManaged, GlobalBatch, GlobalProvisionedManaged, GlobalStandard, and ProvisionedManaged"
  type        = string
  nullable    = false
}

variable "sku_tier" {
  description = "The tier of the SKU (Free, Basic, Standard, Premium, Enterprise)"
  type        = string
  default     = null
}

variable "sku_size" {
  description = "The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code"
  type        = string
  default     = null
}

variable "sku_family" {
  description = "If the service has different generations of hardware, for the same SKU, then that can be captured here"
  type        = string
  default     = null
}

variable "sku_capacity" {
  description = "Tokens-per-Minute (TPM) in thousands. For example, 1 means 1000 tokens per minute"
  type        = number
  default     = null
}

variable "dynamic_throttling_enabled" {
  description = "Whether dynamic throttling is enabled"
  type        = bool
  default     = null
}

variable "rai_policy_name" {
  description = "The name of RAI (Responsible AI) policy"
  type        = string
  default     = null
}

variable "version_upgrade_option" {
  description = "Deployment model version upgrade option. Valid values are OnceNewDefaultVersionAvailable, OnceCurrentVersionExpired, and NoAutoUpgrade"
  type        = string
  default     = "OnceNewDefaultVersionAvailable"

  validation {
    condition     = var.version_upgrade_option == null || contains(["OnceNewDefaultVersionAvailable", "OnceCurrentVersionExpired", "NoAutoUpgrade"], var.version_upgrade_option)
    error_message = "version_upgrade_option must be one of: OnceNewDefaultVersionAvailable, OnceCurrentVersionExpired, NoAutoUpgrade."
  }
}

variable "timeout_create" {
  description = "Timeout for creating the Cognitive Services Account Deployment"
  type        = string
  default     = "30m"
}

variable "timeout_read" {
  description = "Timeout for reading the Cognitive Services Account Deployment"
  type        = string
  default     = "5m"
}

variable "timeout_update" {
  description = "Timeout for updating the Cognitive Services Account Deployment"
  type        = string
  default     = "30m"
}

variable "timeout_delete" {
  description = "Timeout for deleting the Cognitive Services Account Deployment"
  type        = string
  default     = "30m"
}
