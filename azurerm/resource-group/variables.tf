variable "name" {
  description = "The name of the Resource Group"
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.()-]{1,90}$", var.name))
    error_message = "The name must be between 1 and 90 characters and contain only alphanumeric characters, periods, underscores, hyphens, and parentheses."
  }
}

variable "location" {
  description = "The Azure location where the Resource Group should be created"
  type        = string
  nullable    = false

  validation {
    condition     = length(var.location) > 0
    error_message = "Location cannot be empty."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
