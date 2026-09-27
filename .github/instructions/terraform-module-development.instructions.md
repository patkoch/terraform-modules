---
applyTo: "azurerm/**/*.tf"
---

# Terraform Module Development Instructions

Always follow these rules when working in this repository.

- Use `~> 5.7` as the AzureRM provider version constraint in all module `terraform.tf` files.
- Prefer map-based multi-instance modules with `for_each` instead of legacy single-instance resource blocks.
- Run Terraform validation and planning for each changed module.
- Run module tests for any module containing `.tftest.hcl` files after changes.
- Keep secure defaults enabled for Azure Cognitive Services resources unless an explicit override is required.
- Preserve clear, minimal, and explainable module interfaces.
