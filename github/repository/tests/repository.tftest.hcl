mock_provider "github" {}

# Test 1: Minimal configuration uses secure defaults
run "minimal_repository_secure_defaults" {
  command = plan

  variables {
    repositories = {
      app = {
        name = "my-app"
      }
    }
  }

  assert {
    condition     = github_repository.this["app"].name == "my-app"
    error_message = "Repository name should be 'my-app'."
  }

  assert {
    condition     = github_repository.this["app"].visibility == "private"
    error_message = "Repositories must be private by default."
  }

  assert {
    condition     = github_repository.this["app"].delete_branch_on_merge == true
    error_message = "delete_branch_on_merge must be enabled by default."
  }

  assert {
    condition     = github_repository.this["app"].archive_on_destroy == true
    error_message = "archive_on_destroy must be enabled by default to prevent data loss."
  }

  assert {
    condition     = length(github_branch_default.this) == 0
    error_message = "No default branch resource should be planned when default_branch is not set."
  }
}

# Test 2: Multiple repositories with topics, template and custom default branch
run "multiple_repositories_with_options" {
  command = plan

  variables {
    repositories = {
      frontend = {
        name        = "web-frontend"
        description = "Frontend application"
        visibility  = "public"
        topics      = ["terraform", "frontend"]
        has_wiki    = true
        template = {
          owner      = "patkoch"
          repository = "template-repo"
        }
      }
      backend = {
        name               = "api-backend"
        gitignore_template = "Go"
        license_template   = "mit"
        allow_merge_commit = false
        default_branch     = "develop"
      }
    }
  }

  assert {
    condition     = length(github_repository.this) == 2
    error_message = "Exactly two repositories should be planned."
  }

  assert {
    condition     = github_repository.this["frontend"].visibility == "public" && contains(github_repository.this["frontend"].topics, "terraform")
    error_message = "Frontend repository should be public and contain the 'terraform' topic."
  }

  assert {
    condition     = github_repository.this["frontend"].template[0].repository == "template-repo"
    error_message = "Frontend repository should be created from 'template-repo'."
  }

  assert {
    condition     = github_repository.this["backend"].allow_merge_commit == false
    error_message = "Merge commits should be disabled for the backend repository."
  }

  assert {
    condition     = length(github_branch_default.this) == 1 && github_branch_default.this["backend"].branch == "develop"
    error_message = "Only the backend repository should get a default branch 'develop'."
  }
}

# Test 3: Invalid input is rejected by variable validation
run "invalid_name_and_visibility_rejected" {
  command = plan

  variables {
    repositories = {
      bad = {
        name       = "invalid name!"
        visibility = "secret"
      }
    }
  }

  expect_failures = [var.repositories]
}
