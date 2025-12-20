locals {
	# Flatten subnets into a map keyed by "<network_key>-<subnet_name>"
	subnet_map = merge([
		for net_key, net in var.networks : {
			for s in lookup(net, "subnets", []) : "${net_key}-${s.name}" => {
				name                  = s.name
				address_prefixes      = s.address_prefixes
				virtual_network_name  = net.name
				resource_group_name   = net.resource_group_name
				net_key               = net_key
			}
		}
	]...)
}

resource "azurerm_virtual_network" "virtual_networks" {
	for_each = var.networks

	name                = each.value.name
	resource_group_name = each.value.resource_group_name
	location            = each.value.location
	address_space       = each.value.address_space
	tags                = lookup(each.value, "tags", {})
}

resource "azurerm_subnet" "subnets" {
	for_each = local.subnet_map

	name                 = each.value.name
	resource_group_name  = each.value.resource_group_name
	virtual_network_name = each.value.virtual_network_name
	address_prefixes     = each.value.address_prefixes
}

resource "azurerm_network_security_group" "nsgs" {
	for_each = var.networks

	name                = lookup(each.value, "nsg_name", "${each.value.name}-nsg")
	location            = each.value.location
	resource_group_name = each.value.resource_group_name
	tags                = lookup(each.value, "tags", {})
}

# Build a flattened map of NSG rules keyed by "<net_key>-<rule_name>" so we can create rules with for_each
locals {
	nsg_rule_map = merge([
		for net_key, net in var.networks : {
			for r in lookup(net, "nsg_rules", []) : "${net_key}-${r.name}" => merge(r, { net_key = net_key })
		}
	]...)

	# Default deny inbound rule per network when not explicitly allowing inbound internet
	default_deny_map = merge([
		for net_key, net in var.networks : (
			lookup(net, "allow_inbound_internet", false) ? {} : {
				"${net_key}-default-deny-inbound" : {
					name                         = "default-deny-inbound"
					priority                     = 4096
					direction                    = "Inbound"
					access                       = "Deny"
					protocol                     = "*"
					source_address_prefixes      = ["Internet"]
					destination_address_prefixes = ["*"]
					source_port_ranges           = []
					destination_port_ranges      = []
					description                  = "Default deny inbound from internet"
					net_key                      = net_key
				}
			}
		)
	]...)

	all_nsg_rules = merge(local.nsg_rule_map, local.default_deny_map)
}

resource "azurerm_network_security_rule" "nsg_rules" {
	for_each = local.all_nsg_rules

	name                         = each.value.name
	resource_group_name          = azurerm_network_security_group.nsgs[each.value.net_key].resource_group_name
	network_security_group_name  = azurerm_network_security_group.nsgs[each.value.net_key].name
	priority                     = each.value.priority
	direction                    = each.value.direction
	access                       = each.value.access
	protocol                     = each.value.protocol

	source_address_prefixes      = lookup(each.value, "source_address_prefixes", ["*"])
	destination_address_prefixes = lookup(each.value, "destination_address_prefixes", ["*"])

	source_port_ranges           = lookup(each.value, "source_port_ranges", [])
	destination_port_ranges      = lookup(each.value, "destination_port_ranges", [])

	description = lookup(each.value, "description", null)
}

# Optional: send NSG logs to Log Analytics via Diagnostic Setting if workspace id provided per network
resource "azurerm_monitor_diagnostic_setting" "nsg_diag" {
	for_each = { for k, nsg in azurerm_network_security_group.nsgs : k => nsg if lookup(var.networks[k], "log_analytics_workspace_id", null) != null }

	name                       = "${each.value.name}-diag"
	target_resource_id         = each.value.id
	log_analytics_workspace_id = lookup(var.networks[each.key], "log_analytics_workspace_id")

	enabled_log {
		category = "NetworkSecurityGroupEvent"
	}
}

# NSG Flow Logs (Network Watcher)
# Requires module var.network_watcher.name and var.network_watcher.resource_group to be set.
locals {
	nsgs_with_flowlog = {
		for k, nsg in azurerm_network_security_group.nsgs : k => nsg
		if lookup(var.networks[k], "enable_flow_log", false)
			&& lookup(var.networks[k], "flow_log_storage_account_id", null) != null
			&& length(keys(var.network_watcher)) > 0
	}
}

resource "azurerm_network_watcher_flow_log" "nsg_flow_logs" {
	for_each = local.nsgs_with_flowlog

	name                   = "${each.value.name}-flowlog"
	network_watcher_name   = var.network_watcher.name
	resource_group_name    = var.network_watcher.resource_group
	target_resource_id     = each.value.id
	enabled                = true

	storage_account_id = lookup(var.networks[each.key], "flow_log_storage_account_id", null)

	retention_policy {
		enabled = true
		days    = lookup(var.networks[each.key], "flow_log_retention_days", 30)
	}

	traffic_analytics {
		enabled                   = lookup(var.networks[each.key], "enable_traffic_analytics", false)
		workspace_id              = lookup(var.networks[each.key], "log_analytics_workspace_id", null)
		workspace_region          = lookup(var.networks[each.key], "log_analytics_workspace_region", "")
		workspace_resource_id     = lookup(var.networks[each.key], "log_analytics_workspace_resource_id", "")
	}
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
	for_each = { for k, v in local.subnet_map : k => v if contains(keys(azurerm_network_security_group.nsgs), v.net_key) }

	subnet_id                 = azurerm_subnet.subnets[each.key].id
	network_security_group_id = azurerm_network_security_group.nsgs[each.value.net_key].id
}
