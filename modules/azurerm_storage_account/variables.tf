resource "azurerm_storage_account" "sa" {
  for_each = var.storage_accounts

  name                     = each.value.name
  resource_group_name      = var.rg_names[each.value.rg_key]
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  tags                     = each.value.tags
}