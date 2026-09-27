variable "instances" {
  description = "Map of resource groups to create."
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for _, v in var.instances : can(regex("^[a-zA-Z0-9_.()-]{1,90}$", v.name))
    ])
    error_message = "Each resource group name must be between 1 and 90 characters and contain only alphanumeric characters, periods, underscores, hyphens, and parentheses."
  }
}
