resource "azurerm_resource_group" "example" {
    for_each = var.azurerm_kubernetes_clusters
  name     = each.value.name
  location = each.value.location
}

resource "azurerm_kubernetes_cluster" "example" {
    for_each = var.azurerm_kubernetes_clusters
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}
