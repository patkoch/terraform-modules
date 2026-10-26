variable "repositories" {
  description = "Map of GitHub repositories to manage, keyed by a logical instance name."
  type = map(object({
    name                        = string
    description                 = optional(string)
    homepage_url                = optional(string)
    visibility                  = optional(string, "private")
    topics                      = optional(list(string), [])
    has_issues                  = optional(bool, true)
    has_projects                = optional(bool, false)
    has_wiki                    = optional(bool, false)
    has_discussions             = optional(bool, false)
    is_template                 = optional(bool, false)
    auto_init                   = optional(bool, true)
    gitignore_template          = optional(string)
    license_template            = optional(string)
    allow_merge_commit          = optional(bool, true)
    allow_squash_merge          = optional(bool, true)
    allow_rebase_merge          = optional(bool, true)
    allow_auto_merge            = optional(bool, false)
    allow_update_branch         = optional(bool, true)
    delete_branch_on_merge      = optional(bool, true)
    web_commit_signoff_required = optional(bool, false)
    archive_on_destroy          = optional(bool, true)
    archived                    = optional(bool, false)
    default_branch              = optional(string)
    template = optional(object({
      owner                = string
      repository           = string
      include_all_branches = optional(bool, false)
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for _, r in var.repositories : can(regex("^[A-Za-z0-9._-]{1,100}$", r.name)) && !contains([".", ".."], r.name)
    ])
    error_message = "Each repository name must be 1-100 characters long and contain only alphanumeric characters, periods, hyphens, and underscores."
  }

  validation {
    condition = alltrue([
      for _, r in var.repositories : contains(["public", "private", "internal"], r.visibility)
    ])
    error_message = "visibility must be one of: public, private, internal."
  }

  validation {
    condition = alltrue(flatten([
      for _, r in var.repositories : [
        for t in r.topics : can(regex("^[a-z0-9][a-z0-9-]{0,49}$", t))
      ]
    ]))
    error_message = "Each topic must be lowercase, start with a letter or number, contain only letters, numbers, and hyphens, and be at most 50 characters long."
  }

  validation {
    condition = alltrue([
      for _, r in var.repositories : r.allow_merge_commit || r.allow_squash_merge || r.allow_rebase_merge
    ])
    error_message = "At least one merge method (allow_merge_commit, allow_squash_merge, allow_rebase_merge) must be enabled."
  }

  validation {
    condition     = length(distinct([for _, r in var.repositories : lower(r.name)])) == length(var.repositories)
    error_message = "Repository names must be unique (case-insensitive)."
  }
}
