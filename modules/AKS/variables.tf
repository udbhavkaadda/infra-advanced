variable "azurerm_kubernetes_clusters"= {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
}