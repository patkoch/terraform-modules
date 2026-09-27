resource "azurerm_resource_group" "this" {
  for_each = var.instances

  name     = each.value.name
  location = each.value.location
  tags     = each.value.tags

  lifecycle {
    ignore_changes = [tags["LastModified"]]
  }
}
