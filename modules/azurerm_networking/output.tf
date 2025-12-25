output "subnet_ids" {
  value = merge([
    for v in azurerm_virtual_network.vnet :
    { for s in v.subnet : s.name => s.id }
  ]...)
}
output "vnet_ids" {
  value = {
    for k, v in azurerm_virtual_network.vnet :
    k => v.id
  }
}