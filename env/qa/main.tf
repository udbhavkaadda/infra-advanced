terraform {
	backend "azurerm" {
		# Replace with your backend storage account/container
		storage_account_name = ""
		container_name       = ""
		key                  = "qa.terraform.tfstate"
	}
}

provider "azurerm" {
	features = {}
    subscription_id = 
}

data "azurerm_client_config" "current" {}

module "rg" {
	source   = "../../modules/azurerm_resource_group"
	name     = "demo-micro-rg-qa"
	location = var.location
}

module "network" {
	source              = "../../modules/azurerm_networking"
	name                = "demo-vnet-qa"
	location            = var.location
	resource_group_name = module.rg.name
	address_space       = ["10.2.0.0/16"]
	subnets = [
		{ name = "app", address_prefix = "10.2.1.0/24" },
	]
}

module "storage" {
	source              = "../../modules/azurerm_storage_account"
	name                = "demomicroqasa"
	location            = var.location
	resource_group_name = module.rg.name
}

module "keyvault" {
	source              = "../../modules/azurerm_key_vault"
	name                = "demo-micro-kv-qa"
	location            = var.location
	resource_group_name = module.rg.name
	tenant_id           = data.azurerm_client_config.current.tenant_id
}

module "app" {
	source              = "../../modules/azurerm_compute"
	name                = "demo-micro-app-qa"
	location            = var.location
	resource_group_name = module.rg.name
	container_image     = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
	container_port      = 80
	ip_address_type     = "Public"
	cpu                 = 1
	memory              = 1
	subnet_ids          = [module.network.subnet_ids[0]]
}

