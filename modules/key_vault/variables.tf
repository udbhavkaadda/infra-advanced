variable "keyvaults" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku_name            = string
    tenant_id           = string
    soft_delete_enabled = bool
  }))
}