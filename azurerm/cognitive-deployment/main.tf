resource "azurerm_cognitive_deployment" "this" {
  for_each = var.instances

  name                 = each.value.deployment_name
  cognitive_account_id = each.value.cognitive_account_id

  model {
    format  = each.value.model_format
    name    = each.value.model_name
    version = each.value.model_version
  }

  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    size     = each.value.sku_size
    family   = each.value.sku_family
    capacity = each.value.sku_capacity
  }

  dynamic_throttling_enabled = each.value.dynamic_throttling_enabled
  rai_policy_name            = each.value.rai_policy_name
  version_upgrade_option     = each.value.version_upgrade_option

  timeouts {
    create = each.value.timeout_create
    read   = each.value.timeout_read
    update = each.value.timeout_update
    delete = each.value.timeout_delete
  }
}
