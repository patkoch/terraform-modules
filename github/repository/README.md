# GitHub Repository Module

Terraform-Modul zur Verwaltung von GitHub Repositories mit dem Provider
[`integrations/github`](https://registry.terraform.io/providers/integrations/github/latest/docs) (`~> 6.13`, getestet mit v6.13.0).

Das Modul ist – wie die `azurerm`-Module – map-basiert (`for_each`): Mit einem Aufruf können beliebig viele Repositories verwaltet werden.

## Features

- Erstellen und Verwalten von Repositories (`github_repository`)
- Sichere Defaults: `private`, Vulnerability Alerts aktiv, `archive_on_destroy = true` (kein Datenverlust bei `terraform destroy`), Branches werden nach Merge gelöscht
- Vulnerability Alerts über die dedizierte Ressource `github_repository_vulnerability_alerts`
- Optionaler Default Branch (`github_branch_default`)
- Topics, Merge-Strategien, Template-Repositories, `.gitignore`- und Lizenz-Templates
- Eingabevalidierung (Name, Visibility, Topics, Merge-Methoden, eindeutige Namen)

## Dateien

```
github/repository/
├── main.tf / variables.tf / outputs.tf / terraform.tf
├── tests/repository.tftest.hcl          # 3 Tests (terraform test, mit mock_provider)
└── examples/basic/                      # Root-Konfiguration inkl. Provider + terraform.tfvars.example
```

## Eingaben

| Variable | Typ | Default | Beschreibung |
|----------|-----|---------|--------------|
| `repositories` | `map(object)` | `{}` | Map der Repositories, Key = logischer Instanzname |

Attribute je Repository:

| Attribut | Default | Beschreibung |
|----------|---------|--------------|
| `name` | – (Pflicht) | Repository-Name (1-100 Zeichen, `A-Za-z0-9._-`) |
| `description` | `null` | Beschreibung |
| `homepage_url` | `null` | Homepage-URL |
| `visibility` | `"private"` | `public`, `private` oder `internal` |
| `topics` | `[]` | Topics (lowercase, `a-z0-9-`, max. 50 Zeichen) |
| `has_issues` / `has_projects` / `has_wiki` / `has_discussions` | `true` / `false` / `false` / `false` | Features |
| `is_template` | `false` | Repository als Template markieren |
| `auto_init` | `true` | Initialen Commit erzeugen |
| `gitignore_template` | `null` | z. B. `"Go"`, `"Terraform"` |
| `license_template` | `null` | z. B. `"mit"`, `"apache-2.0"` |
| `allow_merge_commit` / `allow_squash_merge` / `allow_rebase_merge` | `true` | Merge-Methoden (mind. eine muss aktiv sein) |
| `allow_auto_merge` | `false` | Auto-Merge erlauben |
| `allow_update_branch` | `true` | "Update branch"-Button |
| `delete_branch_on_merge` | `true` | Head-Branch nach Merge löschen |
| `web_commit_signoff_required` | `false` | Sign-off für Web-Commits |
| `vulnerability_alerts` | `true` | Dependabot Vulnerability Alerts |
| `archive_on_destroy` | `true` | Bei Destroy archivieren statt löschen |
| `archived` | `false` | Repository archivieren |
| `default_branch` | `null` | Default Branch setzen (Branch muss existieren) |
| `template` | `null` | `{ owner, repository, include_all_branches = false }` |

## Outputs

`names`, `full_names`, `html_urls`, `ssh_clone_urls`, `http_clone_urls`, `repo_ids`, `node_ids` – jeweils Maps, Key = Instanzname.

## Anleitung: Nutzung mit Personal Access Token (PAT)

### 1. PAT erstellen

GitHub → *Settings* → *Developer settings* → *Personal access tokens*:

- **Fine-grained token (empfohlen):** Resource owner = dein User bzw. deine Organisation, Repository access = *All repositories*.
  Permissions (Repository): **Administration: Read and write**, **Contents: Read and write**, **Metadata: Read-only**.
- **Classic token:** Scope **`repo`** (für Org-Repos ggf. zusätzlich `read:org`; für das Löschen von Repositories `delete_repo`, falls `archive_on_destroy = false`).

### 2. Token per Umgebungsvariable setzen

Der GitHub-Provider liest das Token automatisch aus der Umgebungsvariable **`GITHUB_TOKEN`**. Das Token gehört **niemals** in `.tf`- oder `terraform.tfvars`-Dateien.

Linux / macOS (bash/zsh):

```bash
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"
# optional statt github_owner in terraform.tfvars:
export GITHUB_OWNER="patkoch"
```

Ohne das Token in der Shell-History zu speichern:

```bash
read -rs GITHUB_TOKEN && export GITHUB_TOKEN
```

Windows PowerShell:

```powershell
$env:GITHUB_TOKEN = "ghp_xxxxxxxxxxxxxxxxxxxx"
$env:GITHUB_OWNER = "patkoch"
```

Mit GitHub CLI (bereits eingeloggt):

```bash
export GITHUB_TOKEN="$(gh auth token)"
```

Der Provider-Block benötigt dann kein `token`-Argument:

```hcl
provider "github" {
  owner = var.github_owner # oder GITHUB_OWNER
}
```

### 3. Konfiguration mit `terraform.tfvars` parametrisieren

Im Beispiel `examples/basic` liegt die Vorlage `terraform.tfvars.example`:

```bash
cd github/repository/examples/basic
cp terraform.tfvars.example terraform.tfvars
```

Beispiel `terraform.tfvars`:

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

Jeder Key der Map (`demo`, `service`, …) ist der stabile Terraform-Key – den Key später nicht umbenennen, sonst wird das Repository neu erstellt.

### 4. Ausführen

```bash
terraform init
terraform plan            # terraform.tfvars wird automatisch geladen
terraform apply
```

Andere Variablendateien: `terraform plan -var-file=prod.tfvars`.

## Direkte Nutzung als Modul

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

## Bestehende Repositories importieren

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

Die Tests nutzen `mock_provider "github"` und benötigen daher **kein** Token:

1. `minimal_repository_secure_defaults` – sichere Defaults (private, Vulnerability Alerts, archive_on_destroy, kein Default-Branch-Resource)
2. `multiple_repositories_with_options` – mehrere Repos, Topics, Template, deaktivierte Merge-Methode, Default Branch
3. `invalid_name_and_visibility_rejected` – ungültiger Name/Visibility wird durch Validierung abgelehnt
