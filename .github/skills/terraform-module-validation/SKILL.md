---
name: terraform-module-validation
description: "Use when: validating Terraform modules, checking module syntax, running plan/validate/test commands, or verifying a change before finishing work in this repository."
---

# Terraform Module Validation

Use this skill whenever a Terraform module is changed.

## Required sequence

Run the following commands from the module directory that was changed:

```bash
terraform init -backend=false
terraform validate
terraform plan
terraform test
```

If the module has no test file, skip `terraform test` and note that no tests are present.

## Repo conventions

- Keep AzureRM provider versions at `~> 5.7`.
- Prefer secure defaults for Azure resource modules.
- Use `for_each`-based multi-instance patterns when creating multiple module instances.
- Do not keep legacy single-instance compatibility paths if the requirement is multi-instance from the ground up.

## Validation expectations

- The module must initialize successfully.
- `terraform validate` must pass.
- `terraform plan` must be run to verify the configuration is safe.
- `terraform test` must pass if test files are present.

## Output requirements

When finishing the task, summarize:

- module path
- commands run
- success or failure per command
- any warnings or follow-up issues
