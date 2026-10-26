# GitHub Repository Module

Terraform module for managing GitHub repositories with the
[`integrations/github`](https://registry.terraform.io/providers/integrations/github/latest/docs) (`~> 6.13`, tested with v6.13.0).

Like the `azurerm` modules, this module uses a map-based (`for_each`) pattern: any number of repositories can be managed in a single module call.

## Features

- Create and manage repositories (`github_repository`)
- Secure defaults: `private`, vulnerability alerts enabled, `archive_on_destroy = true` (preserves data on `terraform destroy`), and branches deleted after merging
- Vulnerability alerts managed through the dedicated `github_repository_vulnerability_alerts` resource
- Optional default branch (`github_branch_default`)
- Topics, merge strategies, template repositories, `.gitignore` and license templates
- Input validation (name, visibility, topics, merge methods, and unique names)

## Files

```
github/repository/
├── main.tf / variables.tf / outputs.tf / terraform.tf
├── tests/repository.tftest.hcl          # 3 tests (terraform test, using mock_provider)
└── examples/basic/                      # Root configuration including provider + terraform.tfvars.example
```

## Inputs

| Variable | Type | Default | Description |
|----------|-----|---------|--------------|
| `repositories` | `map(object)` | `{}` | Map of repositories, keyed by logical instance name |

Attributes for each repository:

| Attribute | Default | Description |
|----------|---------|--------------|
| `name` | – (required) | Repository name (1-100 characters, `A-Za-z0-9._-`) |
| `description` | `null` | Description |
| `homepage_url` | `null` | Homepage URL |
| `visibility` | `"private"` | `public`, `private`, or `internal` |
| `topics` | `[]` | Topics (lowercase, `a-z0-9-`, max. 50 characters) |
| `has_issues` / `has_projects` / `has_wiki` / `has_discussions` | `true` / `false` / `false` / `false` | Features |
| `is_template` | `false` | Mark the repository as a template |
| `auto_init` | `true` | Create an initial commit |
| `gitignore_template` | `null` | e.g. `"Go"`, `"Terraform"` |
| `license_template` | `null` | e.g. `"mit"`, `"apache-2.0"` |
| `allow_merge_commit` / `allow_squash_merge` / `allow_rebase_merge` | `true` | Merge methods (at least one must be enabled) |
| `allow_auto_merge` | `false` | Allow auto-merge |
| `allow_update_branch` | `true` | "Update branch" button |
| `delete_branch_on_merge` | `true` | Delete the head branch after merging |
| `web_commit_signoff_required` | `false` | Require sign-off for web commits |
| `vulnerability_alerts` | `true` | Dependabot vulnerability alerts |
| `archive_on_destroy` | `true` | Archive instead of deleting on destroy |
| `archived` | `false` | Archive the repository |
| `default_branch` | `null` | Set the default branch (the branch must exist) |
| `template` | `null` | `{ owner, repository, include_all_branches = false }` |

## Outputs

`names`, `full_names`, `html_urls`, `ssh_clone_urls`, `http_clone_urls`, `repo_ids`, `node_ids` – each is a map keyed by instance name.

## Using a Personal Access Token (PAT)

### 1. Create a PAT

GitHub → *Settings* → *Developer settings* → *Personal access tokens*:

- **Fine-grained token (recommended):** Resource owner = your user account or organization, Repository access = *All repositories*.
  Repository permissions: **Administration: Read and write**, **Contents: Read and write**, **Metadata: Read-only**.
- **Classic token:** Scope **`repo`** (for organization repositories, you may also need `read:org`; to delete repositories, use `delete_repo` if `archive_on_destroy = false`).

### 2. Set the token as an environment variable

The GitHub provider automatically reads the token from the **`GITHUB_TOKEN`** environment variable. **Never** put the token in `.tf` or `terraform.tfvars` files.

Linux / macOS (bash/zsh):

```bash
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"
# optionally set this instead of github_owner in terraform.tfvars:
export GITHUB_OWNER="patkoch"
```

To avoid storing the token in shell history:

```bash
read -rs GITHUB_TOKEN && export GITHUB_TOKEN
```

Windows PowerShell:

```powershell
$env:GITHUB_TOKEN = "ghp_xxxxxxxxxxxxxxxxxxxx"
$env:GITHUB_OWNER = "patkoch"
```

Using the GitHub CLI (already authenticated):

```bash
export GITHUB_TOKEN="$(gh auth token)"
```

The provider block does not need a `token` argument:

```hcl
provider "github" {
  owner = var.github_owner # or GITHUB_OWNER
}
```

### 3. Parameterize the configuration with `terraform.tfvars`

The `examples/basic` directory contains a `terraform.tfvars.example` template:

```bash
cd github/repository/examples/basic
cp terraform.tfvars.example terraform.tfvars
```

Example `terraform.tfvars`:

```hcl
github_owner = "patkoch"

repositories = {
  demo = {
    name        = "terraform-demo-repo"
    description = "Repository managed by Terraform"
    visibility  = "private"
    topics      = ["terraform", "demo"]
  }

  service = {
    name               = "terraform-demo-service"
    description        = "Service repository"
    visibility         = "public"
    gitignore_template = "Go"
    license_template   = "mit"
    has_discussions    = true
    allow_merge_commit = false
    allow_rebase_merge = false
    default_branch     = "main"
  }

  from_template = {
    name = "service-from-template"
    template = {
      owner      = "patkoch"
      repository = "my-template-repo"
    }
  }
}
```

Each map key (`demo`, `service`, …) is a stable Terraform key. Do not rename it later, or Terraform will recreate the repository.

### 4. Run Terraform

```bash
terraform init
terraform plan            # terraform.tfvars wird automatisch geladen
terraform apply
```

Other variable files: `terraform plan -var-file=prod.tfvars`.

## Use directly as a module

```hcl
provider "github" {
  owner = "patkoch"
}

module "github_repositories" {
  source = "git::https://github.com/patkoch/terraform-modules.git//github/repository?ref=main"

  repositories = {
    app = {
      name        = "my-app"
      description = "My application"
      topics      = ["terraform"]
    }
  }
}
```

## Import existing repositories

```bash
terraform import 'module.repositories.github_repository.this["demo"]' terraform-demo-repo
```

## Tests

```bash
cd github/repository
terraform init -backend=false
terraform validate
terraform test
```

The tests use `mock_provider "github"` and therefore do **not** require a token:

1. `minimal_repository_secure_defaults` – secure defaults (private, vulnerability alerts, archive_on_destroy, no default-branch resource)
2. `multiple_repositories_with_options` – multiple repositories, topics, template, disabled merge method, default branch
3. `invalid_name_and_visibility_rejected` – invalid name/visibility rejected by validation
