variable "storage_accounts" {
  description = "Map of storage accounts to create"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    tier                = string
    replication_type    = string
    tags                = optional(map(string))
  }))
}
