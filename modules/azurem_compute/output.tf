output "fqdn" {
  value = azurerm_container_group.this.fqdn
  description = "FQDN or IP of the container group (if public)"
}

output "id" {
  value = azurerm_container_group.this.id
}
