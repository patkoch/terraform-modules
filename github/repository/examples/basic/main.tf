terraform {
  required_version = ">= 1.15.9"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.13"
    }
  }
}

# The PAT is read from the GITHUB_TOKEN environment variable.
# Never put the token into this file or into terraform.tfvars.
provider "github" {
  owner = var.github_owner
}

module "repositories" {
  source = "../.."

  repositories = var.repositories
}
