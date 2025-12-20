variable "networks" {
  description = "Map of virtual networks to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
    tags                = optional(map(string))
    subnets = optional(list(object({
      name             = string
      address_prefixes = list(string)
    })),[])
    # Optional NSG properties per network
    nsg_name = optional(string)
    # Optional Log Analytics workspace id for NSG diagnostics (optional per-network)
    log_analytics_workspace_id = optional(string)
    # List of security rules for the NSG (map style per network)
    nsg_rules = optional(list(object({
      name                         = string
      priority                     = number
      direction                    = string # "Inbound" or "Outbound"
      access                       = string # "Allow" or "Deny"
      protocol                     = string # "Tcp" | "Udp" | "*"
      source_address_prefixes      = optional(list(string), ["*"])
      destination_address_prefixes = optional(list(string), ["*"])
      source_port_ranges           = optional(list(string), [])
      destination_port_ranges      = optional(list(string), [])
      description                  = optional(string)
    })), [])
    # Whether to allow inbound internet traffic to this network. Default false — module will add a default deny-inbound rule when false.
    allow_inbound_internet = optional(bool, false)
    # Flow log related optional settings (per-network)
    enable_flow_log = optional(bool, false)
    # If you want the module to attach flow logs to this NSG, provide an existing storage account id.
    flow_log_storage_account_id = optional(string)
    # Retention in days for flow logs
    flow_log_retention_days = optional(number, 30)
    # Enable traffic analytics to Log Analytics workspace (requires log_analytics_workspace_id)
    enable_traffic_analytics = optional(bool, false)
  }))
}

variable "_validation_dummy" {
  description = "Internal validation helper to ensure NSG rule names and priorities are unique per network"
  type        = any
  default     = null

  validation {
    condition = alltrue([
      for net in values(var.networks) : (
        (
          length([for r in lookup(net, "nsg_rules", []) : r.name]) == length(distinct([for r in lookup(net, "nsg_rules", []) : r.name]))
        ) && (
          length([for r in lookup(net, "nsg_rules", []) : r.priority]) == length(distinct([for r in lookup(net, "nsg_rules", []) : r.priority]))
        )
      )
    ])

    error_message = "Duplicate NSG rule names or priorities detected in one or more networks. Ensure each network's 'nsg_rules' list contains unique 'name' and 'priority' values."
  }
}

# Additional validation for global uniqueness of priorities when enabled
variable "_global_priority_validation" {
  type    = any
  default = null

  validation {
    condition = (
      var.global_unique_priorities == false
      || (
        length(flatten([for net in values(var.networks) : [for r in lookup(net, "nsg_rules", []) : r.priority]])) == length(distinct(flatten([for net in values(var.networks) : [for r in lookup(net, "nsg_rules", []) : r.priority]])))
      )
    )
    error_message = "Duplicate NSG rule priority values found across networks. Set 'global_unique_priorities = false' to disable this check if duplicates are intentional per-NSG."
  }
}

variable "network_watcher" {
  description = "Optional Network Watcher information used for enabling NSG Flow Logs. If not provided, flow logs cannot be created by this module."
  type = object({
    name              = optional(string)
    resource_group    = optional(string)
  })
  default = {}
}

variable "global_unique_priorities" {
  description = "When true, enforce globally-unique NSG rule priorities across all networks in the module. Default true to avoid cross-NSG collisions if desired."
  type        = bool
  default     = true
}
