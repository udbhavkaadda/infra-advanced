variable "networks" {
  type = map(object({
    name          = string
    rg_key        = string
    location      = string
    address_space = list(string)
    subnets = map(object({
      name             = string
      address_prefixes = list(string)
    }))
    tags = map(string)
  }))
}
variable "rg_names" { type = map(string) }