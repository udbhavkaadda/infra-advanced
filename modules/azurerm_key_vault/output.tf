output "id" {
  description = "Map of Key Vault IDs"
  value       = { for k, v in azurerm_key_vault.kv : k => v.id }
}

output "vault_uri" {
  description = "Map of Key Vault URIs"
  value       = { for k, v in azurerm_key_vault.kv : k => v.vault_uri }
}
