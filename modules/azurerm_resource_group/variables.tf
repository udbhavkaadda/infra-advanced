variable "rgs" {
  description = "Map of resource groups to create"
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
    tags       = optional(map(string))
  }))
}
