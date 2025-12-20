terraform {
	backend "azurerm" {
		# Replace the values below with your backend storage account and container
		storage_account_name = "REPLACE_WITH_STORAGE_ACCOUNT"
		container_name       = "tfstate"
		key                  = "dev.terraform.tfstate"
	}
}

provider "azurerm" {
    features {}
}

module "rg" {
	source = "../../modules/azurerm_resource_group"
	rgs    = var.rgs
}

module "network" {
	source   = "../../modules/azurerm_networking"
	networks = var.networks
}

module "storage" {
	source           = "../../modules/azurerm_storage_account"
	storage_accounts = var.storage_accounts
}

module "keyvault" {
	source     = "../../modules/azurerm_key_vault"
	key_vaults = var.key_vaults
}

data "azurerm_client_config" "current" {}

module "app" {
	source = "../../modules/azurem_compute"
	vms    = var.vms
}

