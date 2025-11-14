terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.49.0"
    }
  }
#   backend "azurerm" {
#     resource_group_name  = "udbhav_rg"
#     storage_account_name = "udbhavstorage"
#     container_name       = "udbhavcontainer"
#     key                  = "dev.tfstate"
#   }
}

provider "azurerm" {
  features {}
  subscription_id = "02fc6674-9e4d-4764-8702-0c4550e06df7"
}