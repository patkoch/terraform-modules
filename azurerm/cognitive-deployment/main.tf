resource "azurerm_cognitive_deployment" "this" {
  name                 = var.deployment_name
  cognitive_account_id = var.cognitive_account_id

  model {
    format  = var.model_format
    name    = var.model_name
    version = var.model_version
  }

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    size     = var.sku_size
    family   = var.sku_family
    capacity = var.sku_capacity
  }

  dynamic_throttling_enabled = var.dynamic_throttling_enabled
  rai_policy_name            = var.rai_policy_name
  version_upgrade_option     = var.version_upgrade_option

  timeouts {
    create = var.timeout_create
    read   = var.timeout_read
    update = var.timeout_update
    delete = var.timeout_delete
  }
}
