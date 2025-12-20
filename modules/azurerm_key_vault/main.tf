data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each                    = var.key_vaults
  name                        = each.value.name
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  tenant_id                   = lookup(each.value, "tenant_id", data.azurerm_client_config.current.tenant_id)
  sku_name                    = lookup(each.value, "sku_name", "standard")
  purge_protection_enabled    = lookup(each.value, "purge_protection", true)
  soft_delete_retention_days  = lookup(each.value, "soft_delete_days", 7)

  dynamic "access_policy" {
    for_each = lookup(each.value, "access_policies", {})
    content {
      tenant_id = lookup(access_policy.value, "tenant_id", data.azurerm_client_config.current.tenant_id)
      object_id = access_policy.value.object_id

      key_permissions     = lookup(access_policy.value, "key_permissions", [])
      secret_permissions  = lookup(access_policy.value, "secret_permissions", [])
      storage_permissions = lookup(access_policy.value, "storage_permissions", [])
    }
  }

  # Optional network ACLs
  dynamic "network_acls" {
    for_each = lookup(each.value, "network_acls", length(lookup(each.value, "network_acls", null)) == 0 ? [] : [lookup(each.value, "network_acls")])
    content {
      bypass         = lookup(network_acls.value, "bypass", "AzureServices")
      default_action = lookup(network_acls.value, "default_action", "Deny")
      ip_rules       = lookup(network_acls.value, "ip_rules", [])
      virtual_network_subnet_ids = lookup(network_acls.value, "virtual_network_subnet_ids", [])
    }
  }

  tags = lookup(each.value, "tags", {})
}

output "key_vault_ids" {
  value = { for k, v in azurerm_key_vault.kv : k => v.id }
}

