variable "project" {
	description = "Project or application name"
	type        = string
	default     = "demo-micro"
}

variable "environment" {
	description = "Environment name (dev/qa/prod)"
	type        = string
	default     = "dev"
}

variable "location" {
	description = "Azure region to deploy into"
	type        = string
	default     = "eastus"
}

variable "subscription_id" {
    description = "Azure Subscription ID"
    type        = string
}
