# Azure Resource Group Module

Dieses Terraform Modul erstellt eine Azure Resource Group als Basis für die Verwaltung von Azure-Ressourcen. Eine Resource Group ist ein logischer Container, in dem Azure-Ressourcen bereitgestellt und verwaltet werden.

## Features

- Einfache und nicht-invasive Resource Group Erstellung
- Flexible Tag-Verwaltung
- Umfassende Name- und Location-Validierung
- Automatische Lifecycle-Verwaltung von geänderten Tags

## Verwendungsbeispiele

### Einfache Resource Group

```hcl
module "resource_group" {
  source = "./resource-group"

  name     = "my-resources"
  location = "eastus"
}
```

### Resource Group mit Tags

```hcl
module "resource_group" {
  source = "./resource-group"

  name     = "prod-resources"
  location = "westeurope"

  tags = {
    Environment = "Production"
    Project     = "MyProject"
    Owner       = "TeamA"
    CostCenter  = "12345"
  }
}
```

### Multiple Resource Groups für verschiedene Umgebungen

```hcl
module "dev_resource_group" {
  source = "./resource-group"

  name     = "dev-resources"
  location = "eastus"

  tags = {
    Environment = "Development"
    Project     = "MyProject"
  }
}

module "prod_resource_group" {
  source = "./resource-group"

  name     = "prod-resources"
  location = "westeurope"

  tags = {
    Environment = "Production"
    Project     = "MyProject"
    Backup      = "Daily"
  }
}
```

## Anforderungen

- Terraform >= 1.13
- Azure RM Provider >= 4.60
- Authentifizierte Azure CLI oder Service Principal

## Eingabe-Variablen

### Erforderlich

| Name | Beschreibung | Type |
|------|-----------|------|
| `name` | Name der Resource Group | `string` |
| `location` | Azure Region (z.B. eastus, westeurope) | `string` |

### Optional

| Name | Beschreibung | Type | Standard |
|------|-----------|------|---------|
| `tags` | Mapping von Tags | `map(string)` | `{}` |

## Ausgaben

| Name | Beschreibung |
|------|-----------|
| `id` | Die ID der Resource Group |
| `name` | Der Name der Resource Group |
| `location` | Die Location der Resource Group |

## Gültige Azure Locations

Häufig verwendete Locations:

| Region | Location |
|--------|----------|
| US - Osten | `eastus` |
| US - Osten 2 | `eastus2` |
| US - Westen | `westus` |
| US - Westen 2 | `westus2` |
| Deutschland - Mitte | `germanycentral` |
| Deutschland - Nordosten | `germanynortheast` |
| UK - Süden | `uksouth` |
| UK - Westen | `ukwest` |
| Westeuropa | `westeurope` |
| Nordeuropa | `northeurope` |
| Frankreich - Mitte | `francecentral` |
| Schweiz - Norden | `switzerlandnorth` |
| Australien - Osten | `australiaeast` |
| Australien - Südosten | `australiasoutheast` |
| Singapur | `southeastasia` |
| Japan - Osten | `japaneast` |
| Südkorea - Mitte | `koreacentral` |
| Indien - Mitte | `centralindia` |

Für eine vollständige Liste aller verfügbaren Locations können Sie folgende Azure CLI Command ausführen:

```bash
az account list-locations --query "[].name" -o table
```

## Naming Convention Richtlinien

Azure Resource Group Namen müssen folgende Anforderungen erfüllen:

- **Länge**: 1-90 Zeichen
- **Erlaubte Zeichen**: Alphanumeric, Period (.), Underscore (_), Hyphen (-), Parenthesis ( )
- **Eindeutigkeit**: Namen müssen innerhalb des Azure Subscriptions eindeutig sein
- **Keine Leerzeichen**: Vermeiden Sie Leerzeichen im Namen

### Empfohlene Naming Convention

```
{environment}-{project}-{purpose}
```

Beispiele:
- `dev-myproject-resources`
- `prod-webapi-rg`
- `staging-database-infra`
- `dev_ml_training_job`

## Gültige Tag-Namen und -Werte

Tags sollten folgende Best Practices berücksichtigen:

```hcl
tags = {
  Environment     = "Development"      # Umgebung (Development, Staging, Production)
  Project         = "ProjectName"      # Projektname
  Owner           = "TeamName"         # Verantwortliches Team
  CostCenter      = "12345"            # Kostenstelle
  Application     = "AppName"          # Anwendungsname
  BackupPolicy    = "Daily"            # Sicherungsstrategie
  Compliance      = "GDPR"             # Compliance-Anforderungen
  CreatedDate     = "2026-02-15"       # Erstellungsdatum
  ManagedBy       = "Terraform"        # Verwaltungstool
}
```

## Beispiel Integration mit anderen Modulen

Die Resource Group wird typischerweise als Basis für andere Azure-Ressourcen verwendet:

```hcl
module "resource_group" {
  source = "./resource-group"

  name     = "prod-ai-resources"
  location = "eastus"

  tags = {
    Environment = "Production"
    Project     = "AI-Platform"
  }
}

# Cognitive Account in der Resource Group
module "cognitive_account" {
  source = "./cognitive-account"

  name                = "myopenai"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  kind                = "OpenAI"
  sku_name            = "S0"

  custom_subdomain_name = "myopenai"

  tags = module.resource_group.id
}

# Cognitive Deployment in der Resource Group
module "cognitive_deployment" {
  source = "./cognitive-deployment"

  deployment_name      = "gpt4-deployment"
  cognitive_account_id = module.cognitive_account.id

  model_format = "OpenAI"
  model_name   = "gpt-4"
  model_version = "1106-preview"

  sku_name     = "Standard"
  sku_capacity = 10
}
```

## Lifecycle Management

Das Modul ignoriert automatisch Tag-Änderungen mit dem Schlüssel `LastModified`, um Konflikte mit automatischen Tag-Updates zu vermeiden. Falls Sie diesen Verhalten ändern möchten, können Sie den `lifecycle` Block in der `main.tf` anpassen.

## Import einer existierenden Resource Group

Sie können eine bereits in Azure vorhandene Resource Group in Ihren Terraform State importieren:

```bash
terraform import azurerm_resource_group.example /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}
```

## Referenzen

- [Terraform Azure RM Provider - Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [Azure Resource Groups Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal)
- [Azure Naming and Tagging Strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging)
