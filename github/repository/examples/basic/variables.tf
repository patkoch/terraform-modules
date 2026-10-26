variable "github_owner" {
  description = "GitHub user or organization that owns the repositories. Can also be set via the GITHUB_OWNER environment variable when left null."
  type        = string
  default     = null
}

variable "repositories" {
  description = "Map of repositories passed to the module. See ../../variables.tf for all attributes."
  type        = any
  default     = {}
}
