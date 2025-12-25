resource "azurerm_public_ip" "pip" {
  for_each = var.public_ips

  name                = each.value.name
  resource_group_name = var.rg_names[each.value.rg_key]
  location            = each.value.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = each.value.tags
}