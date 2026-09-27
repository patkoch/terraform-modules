---
name: terraform-change-guard
description: "Use when: reviewing a Terraform change, ensuring a module still passes validation, or checking whether a change introduced regressions. This skill enforces a safety check before finalizing edits."
---

# Terraform Change Guard

Run this skill before completing any Terraform modification.

## Minimum required checks

For every changed module directory, run:

```bash
terraform init -backend=false
terraform validate
terraform plan
terraform test
```

## Guardrails

- Do not finalize changes without validation output.
- If tests fail, fix the root cause before finishing.
- Keep provider constraints at `~> 5.7`.
- Preserve the `for_each` multi-instance design.
- Avoid reintroducing legacy single-instance behavior.

## Summary

Return a concise report with:

- changed module
- commands executed
- result of each command
- remaining issues, if any
