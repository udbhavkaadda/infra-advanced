resource "azurerm_virtual_network" "vnet" {
  for_each = var.networks

  name                = each.value.name
  location            = each.value.location
  resource_group_name = var.rg_names[each.value.rg_key]
  address_space       = each.value.address_space
  tags                = each.value.tags

  dynamic "subnet" {
    for_each = each.value.subnets
    content {
      name             = subnet.value.name
      address_prefixes = subnet.value.address_prefixes
    }
  }
}