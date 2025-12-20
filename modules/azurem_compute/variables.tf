variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "container_image" { type = string }
variable "container_port" {
  type    = number
  default = 80
}
variable "cpu" {
  type    = number
  default = 0.5
}
variable "memory" {
  type    = number
  default = 1.0
}
variable "ip_address_type" {
  type    = string
  default = "Public"
}
variable "subnet_ids" {
  type    = list(string)
  default = []
}
variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    nic_name    = string
    location    = string
    rg_name     = string
    vnet_name   = string
    subnet_name = string
    pip_name    = string
    vm_name     = string
    size        = string
    publisher   = string
    offer       = string
    sku         = string
    version     = string
    kv_name     = string
  }))
}
