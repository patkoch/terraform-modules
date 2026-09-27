variable "instances" {
  description = "Map of cognitive deployments to create."
  type = map(object({
    deployment_name            = string
    cognitive_account_id       = string
    model_format               = string
    model_name                 = string
    model_version              = optional(string)
    sku_name                   = string
    sku_tier                   = optional(string)
    sku_size                   = optional(string)
    sku_family                 = optional(string)
    sku_capacity               = optional(number)
    dynamic_throttling_enabled = optional(bool)
    rai_policy_name            = optional(string)
    version_upgrade_option     = optional(string, "OnceNewDefaultVersionAvailable")
    timeout_create             = optional(string, "30m")
    timeout_read               = optional(string, "5m")
    timeout_update             = optional(string, "30m")
    timeout_delete             = optional(string, "30m")
  }))
  default = {}

  validation {
    condition = alltrue([
      for _, v in var.instances : contains(["OnceNewDefaultVersionAvailable", "OnceCurrentVersionExpired", "NoAutoUpgrade"], v.version_upgrade_option)
    ])
    error_message = "Each deployment version_upgrade_option must be one of: OnceNewDefaultVersionAvailable, OnceCurrentVersionExpired, NoAutoUpgrade."
  }
}
