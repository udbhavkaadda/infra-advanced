variable "storage_accounts" {
  type = map(object({
    name                     = string
    rg_key                   = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    tags                     = map(string)
  }))
}

variable "rg_names" { type = map(string) }