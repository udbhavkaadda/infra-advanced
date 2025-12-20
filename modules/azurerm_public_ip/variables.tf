
variable "public_ips" {
	description = "Map of public IP definitions. Keyed by an arbitrary id."
	type = map(object({
		name                      = string
		resource_group_name       = string
		location                  = string
		allocation_method         = optional(string) # Static | Dynamic
		sku                       = optional(string)
		sku_tier                  = optional(string)
		zones                     = optional(list(string))
		ip_version                = optional(string)
		domain_name_label         = optional(string)
		ddos_protection_mode      = optional(string)
		ddos_protection_plan_id   = optional(string)
		edge_zone                 = optional(string)
		idle_timeout_in_minutes   = optional(number)
		ip_tags                   = optional(map(string))
		public_ip_prefix_id       = optional(string)
		reverse_fqdn              = optional(string)
		tags                      = optional(map(string))
	}))
	default = {}
}

variable "default_tags" {
	description = "Default tags to apply to all public IPs; merged with per-resource tags."
	type        = map(string)
	default     = {}
}

variable "create_before_destroy" {
	description = "Lifecycle create_before_destroy for public IPs (true recommended to avoid downtime)."
	type        = bool
	default     = true
}

