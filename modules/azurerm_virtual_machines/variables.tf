variable "vms" {
  type = map(object({
    name       = string
    rg_key     = string
    location   = string
    subnet_key = string
    vm_size    = string
    admin_user = string
    admin_pass = string
    tags       = map(string)
  }))
}
variable "rg_names" { type = map(string) }
variable "subnet_ids" { type = map(string) }
variable "key_vault_id" {
  type = string
}