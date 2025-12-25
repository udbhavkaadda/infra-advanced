terraform {
  required_version = ">= 1.4.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = ">= 3.0" }
    random  = { source = "hashicorp/random", version = ">= 3.0" }
  }
}

provider "azurerm" {
  features {}
  use_cli         = true
  subscription_id = "89eb5bd1-6882-47f4-8d86-ac7dad66b5ae"
}