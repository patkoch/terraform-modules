# Azure OpenAI Service Deployment Configuration

This directory contains a complete Terraform configuration for deploying an Azure OpenAI Service with the GPT-4o model.

## Deployment Architecture

This configuration deploys the following components:

1. **Resource Group** - Logical container for all resources
2. **Cognitive Account** - Azure OpenAI Service Account
3. **Cognitive Deployment** - GPT-4o Model Deployment

## Configured Values

```
Resource Group:
  Name: open-ai-test-west-europe-rg
  Location: West Europe

Cognitive Account:
  Name: open-ai-test-west-europe-ca
  Kind: OpenAI
  SKU: S0
  Custom Subdomain: open-ai-test-west-europe
  Identity: System Assigned

Cognitive Deployment:
  Name: open-ai-test-west-europe-cd
  Model: gpt-4o
  Model Version: 2024-11-20
  Model Format: OpenAI
  SKU: GlobalStandard
  Capacity: 45 (45,000 tokens per minute)
```

## Prerequisites

- Terraform >= 1.13
- Azure CLI or Service Principal configured
- Authentication with Azure (`az login` or environment variables)
- Sufficient permissions in the Azure subscription

## Usage

### 1. Review and customize variables (optional)

The configuration contains predefined values. If you want to change them, you can modify the `main.tf` file.

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the plan

```bash
terraform plan
```

### 4. Deploy

```bash
terraform apply
```

### 5. Get access credentials

After successful deployment, retrieve access information using `terraform output`:

```bash
# Display all outputs
terraform output

# Endpoint URL
terraform output cognitive_account_endpoint

# Service Summary
terraform output openai_service_summary

# Primary API Key (Warning - sensitive!)
terraform output cognitive_account_primary_key
```

## Configuration Structure

```
openai-deployment/
├── provider.tf           # Terraform & Azure Provider Configuration
├── main.tf              # Module calls (Resource Group, Account, Deployment)
├── outputs.tf           # Output definitions
├── README.md            # This file
└── terraform.tfstate    # State file (after first apply)
```

## Modules

This configuration uses the following modules:

- **../resource-group** - Creates an Azure Resource Group
- **../cognitive-account** - Creates a Cognitive Services Account (OpenAI)
- **../cognitive-deployment** - Creates a Deployment with GPT-4o model

## Important Outputs

After deployment, the following information is available:

| Output | Description |
|--------|-------------|
| `resource_group_name` | Name of the Resource Group |
| `cognitive_account_endpoint` | API Endpoint URL |
| `cognitive_account_primary_key` | Primary API Key (sensitive) |
| `cognitive_account_secondary_key` | Secondary API Key (sensitive) |
| `cognitive_deployment_id` | Deployment ID |
| `openai_service_summary` | Complete summary |

## Cleanup

To delete all resources:

```bash
terraform destroy
```

## Best Practices

### 1. Protect the State File

The `terraform.tfstate` file contains sensitive data such as API keys. Protect this file:

```bash
# Ignore state file in git
echo "terraform.tfstate*" >> .gitignore
```

### 2. Use Remote State

For production, you should use remote state:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state"
    storage_account_name = "tfstate"
    container_name       = "tfstate"
    key                  = "openai.tfstate"
  }
}
```

### 3. Secrets Management

API keys should not be stored in version control:

```bash
# Get output without echoing
terraform output cognitive_account_primary_key

# Or use as environment variable
export OPENAI_API_KEY=$(terraform output -raw cognitive_account_primary_key)
```

### 4. Update Tags

Customize the tags in `main.tf` according to your requirements:

```hcl
tags = {
  Project     = "OpenAI-Test"
  Environment = "Production"  # Change this
  Owner       = "TeamName"    # Add owner
  CostCenter  = "12345"       # Cost center
}
```

## Troubleshooting

### Issue: "The kind value is not valid"

- Make sure `kind = "OpenAI"` is spelled exactly right

### Issue: "Location is not available for this resource type"

- Verify that GPT-4o is available in "West Europe"
- Alternative locations: "eastus", "australiaeast"

### Issue: "Capacity not available"

- The capacity of 45 TCUs might not be available in the region
- Adjust `sku_capacity` or use different SKU names

### Issue: "Custom Subdomain is already taken"

- Subdomains must be globally unique
- Change `custom_subdomain_name` in `main.tf`

## Additional Resources

- [Azure OpenAI Service Documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/)
- [GPT-4o Model Details](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#gpt-4-and-gpt-4-turbo)
- [Terraform Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Cognitive Services Pricing](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/)

## Support

For issues or questions:

1. Check the `terraform plan` output carefully
2. Read Azure error messages
3. Consult the official documentation
4. Check Terraform logs with `TF_LOG=DEBUG`
