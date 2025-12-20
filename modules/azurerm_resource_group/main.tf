resource "azurerm_resource_group" "rgs" {
	for_each = var.rgs

	name     = each.value.name
	location = each.value.location
	managed_by = lookup(each.value, "managed_by", null)
	tags     = lookup(each.value, "tags", {})
}
