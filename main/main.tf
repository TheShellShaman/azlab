terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100" # or latest stable
    }
  }

  required_version = ">= 1.4.0"
}

provider "azurerm" {
  features {}
}

