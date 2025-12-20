terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features = {}
  # Optionally set subscription_id via variable or environment
  # subscription_id = var.subscription_id
}
