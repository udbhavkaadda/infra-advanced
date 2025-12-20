output "vnet_ids" {
  description = "Map of virtual network ids"
  value       = { for k, v in azurerm_virtual_network.virtual_networks : k => v.id }
}

output "subnet_ids" {
  description = "Map of subnet ids keyed by <network_key>-<subnet_name>"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "nsg_ids" {
  description = "Map of network security group ids"
  value       = { for k, v in azurerm_network_security_group.nsgs : k => v.id }
}

output "nsg_rule_ids" {
  description = "Map of network security rule ids keyed by <network_key>-<rule_name>"
  value       = { for k, v in azurerm_network_security_rule.nsg_rules : k => v.id }
}

output "nsg_diagnostic_ids" {
  description = "Map of NSG diagnostic setting ids keyed by network key (only present when configured)"
  value       = { for k, v in azurerm_monitor_diagnostic_setting.nsg_diag : k => v.id }
}

output "nsg_flow_log_ids" {
  description = "Map of NSG flow log ids keyed by network key (only present when configured)"
  value       = length(azurerm_network_watcher_flow_log.nsg_flow_logs) > 0 ? { for k, v in azurerm_network_watcher_flow_log.nsg_flow_logs : k => v.id } : {}
}
