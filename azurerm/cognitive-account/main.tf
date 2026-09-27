resource "azurerm_cognitive_account" "this" {
  for_each = var.instances

  #checkov:skip=CKV2_AZURE_22: "Customer-managed key encryption requires a user-provided Key Vault key ID and cannot be enforced by the module itself. Configure the customer_managed_key variable to comply with this policy."
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  kind                = each.value.kind
  sku_name            = each.value.sku_name

  custom_subdomain_name = each.value.custom_subdomain_name

  dynamic_throttling_enabled         = each.value.dynamic_throttling_enabled
  local_auth_enabled                 = coalesce(each.value.local_auth_enabled, false)
  outbound_network_access_restricted = coalesce(each.value.outbound_network_access_restricted, false)
  public_network_access_enabled      = coalesce(each.value.public_network_access_enabled, false)
  project_management_enabled         = coalesce(each.value.project_management_enabled, false)

  fqdns = each.value.fqdns

  # MetricsAdvisor specific properties
  metrics_advisor_aad_client_id   = each.value.metrics_advisor_aad_client_id
  metrics_advisor_aad_tenant_id   = each.value.metrics_advisor_aad_tenant_id
  metrics_advisor_super_user_name = each.value.metrics_advisor_super_user_name
  metrics_advisor_website_name    = each.value.metrics_advisor_website_name

  # QnAMaker properties
  qna_runtime_endpoint = each.value.qna_runtime_endpoint

  # TextAnalytics custom question answering
  custom_question_answering_search_service_id  = each.value.custom_question_answering_search_service_id
  custom_question_answering_search_service_key = each.value.custom_question_answering_search_service_key

  # Optional blocks
  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_acls" {
    for_each = each.value.network_acls != null ? [each.value.network_acls] : []
    content {
      default_action = network_acls.value.default_action
      bypass         = network_acls.value.bypass
      ip_rules       = network_acls.value.ip_rules

      dynamic "virtual_network_rules" {
        for_each = network_acls.value.virtual_network_rules != null ? network_acls.value.virtual_network_rules : []
        content {
          subnet_id                            = virtual_network_rules.value.subnet_id
          ignore_missing_vnet_service_endpoint = virtual_network_rules.value.ignore_missing_vnet_service_endpoint
        }
      }
    }
  }

  dynamic "network_injection" {
    for_each = each.value.network_injection != null ? [each.value.network_injection] : []
    content {
      scenario  = network_injection.value.scenario
      subnet_id = network_injection.value.subnet_id
    }
  }

  dynamic "customer_managed_key" {
    for_each = each.value.customer_managed_key != null ? [each.value.customer_managed_key] : []
    content {
      key_vault_key_id   = customer_managed_key.value.key_vault_key_id
      identity_client_id = customer_managed_key.value.identity_client_id
    }
  }

  dynamic "storage" {
    for_each = each.value.storage != null ? each.value.storage : []
    content {
      storage_account_id = storage.value.storage_account_id
      identity_client_id = storage.value.identity_client_id
    }
  }

  tags = each.value.tags

  timeouts {
    create = each.value.timeout_create
    read   = each.value.timeout_read
    update = each.value.timeout_update
    delete = each.value.timeout_delete
  }
}
