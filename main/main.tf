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

resource "azurerm_resource_group" "azlab" {
  name = var.resourcegroup
  location = var.location
  tags = {
    env = "prod"
  }
}

module "network" {
  source = "../modules/network"
  resourcegroup = var.resourcegroup
  location = var.location
}

module "storage" {
  source = "../modules/storage"
  resourcegroup = var.resourcegroup
  location = var.location
  production-subnet = module.network.production-subnet
}

module "dns" {
  source = "../modules/DNS"
  resourcegroup = var.resourcegroup
  location = var.location
}