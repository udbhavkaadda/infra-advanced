terraform {
  backend "azurerm" {
    # Replace the values below with your backend storage account and container
    storage_account_name = "REPLACE_WITH_STORAGE_ACCOUNT"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features = {}
}

data "azurerm_client_config" "current" {}

module "rg" {
  source   = "../../modules/azurerm_resource_group"
  rgs = var.rgs
}

module "network" {
  source   = "../../modules/azurerm_networking"
  networks = var.networks
}

module "public_ip" {
  source     = "../../modules/azurerm_public_ip"
  public_ips = var.public_ips
}

module "key_vault" {
  source     = "../../modules/azurerm_key_vault"
  key_vaults = var.key_vaults
}

module "sql_server" {
  source          = "../../modules/azruerm_sql_server"
  sql_server_name = "sql-prod-example"
  rg_name         = "${keys(var.rgs)[0]}"
  location        = var.location
  admin_username  = "REPLACEME"
  admin_password  = "REPLACEME"
}

module "sql_db" {
  source      = "../../modules/azurerm_sql_database"
  sql_db_name = "sqldb-prod"
  server_id   = module.sql_server.server_id
  max_size_gb = "2"
}

module "azurerm_compute" {
  source = "../../modules/azurem_compute"
  vms    = var.vms
}

module "azurerm_storage_account" {
  source           = "../../modules/azurerm_storage_account"
  storage_accounts = var.storage_accounts
}
