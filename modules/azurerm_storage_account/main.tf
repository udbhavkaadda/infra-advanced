resource "azurerm_storage_account" "sa" {
	for_each = var.storage_accounts

	name                     = each.value.name
	resource_group_name      = each.value.resource_group_name
	location                 = each.value.location
	account_tier             = each.value.tier
	account_replication_type = each.value.replication_type
	min_tls_version          = "TLS1_2"
	https_traffic_only_enabled = true

	tags = lookup(each.value, "tags", {})
}

output "storage_accounts" {
	value = { for k, v in azurerm_storage_account.sa : k => {
		name = v.name
		id   = v.id
	} }
}
