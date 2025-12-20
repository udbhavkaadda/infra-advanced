variable "key_vaults" {
  description = "Map of key vaults to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    tenant_id           = optional(string)
    sku_name            = optional(string, "standard")
    purge_protection    = optional(bool, true)
    soft_delete_days    = optional(number, 7)
    tags                = optional(map(string), {})
    # Optional map of access policies keyed by identifier. Each policy object supports:
    # { tenant_id = string, object_id = string, key_permissions = list(string), secret_permissions = list(string), storage_permissions = list(string) }
    access_policies     = optional(map(object({
      tenant_id        = optional(string)
      object_id        = string
      key_permissions  = optional(list(string), [])
      secret_permissions = optional(list(string), [])
      storage_permissions = optional(list(string), [])
    })), {})
    # Optional network ACLs configuration (object) - if omitted, vault will use default network settings
    network_acls = optional(object({
      bypass         = optional(string, "AzureServices")
      default_action = optional(string, "Deny")
      ip_rules       = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }), null)
  }))
}
