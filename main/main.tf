terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117.0" # or latest stable
    }
  }

  required_version = ">= 1.4.0"
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "azlab"
    storage_account_name = "tfstoragejacobslab"
    container_name       = "tfstate"
    key                  = "main.terraform.tfstate"
  }
}

resource "azurerm_resource_group" "azlab" {
  name     = var.resourcegroup
  location = var.location
  tags = {
    env = "prod"
  }
}

resource "azurerm_resource_group" "functionsrg" {
  name     = var.functionsrg
  location = var.location
  tags = {
    env = "prod"
  }
  
}
module "network" {
  source        = "../modules/network"
  resourcegroup = var.resourcegroup
  location      = var.location
}

module "storage" {
  source            = "../modules/storage"
  resourcegroup     = var.resourcegroup
  location          = var.location
  production-subnet = module.network.production-subnet
  appservice_subnet = module.network.appservice_subnet
  functionsrg      = var.functionsrg
}

module "dns" {
  source        = "../modules/DNS"
  resourcegroup = var.resourcegroup
  location      = var.location
}

module "appservice" {
  source            = "../modules/appservice"
  resourcegroup     = var.resourcegroup
  functionsrg      = var.functionsrg
  location          = var.location
  storageaccountid  = module.storage.storageaccountid
  appservice_subnet = module.network.appservice_subnet
  storageaccountname = module.storage.storageaccountname
  highscorestablename = module.storage.highscorestablename
}
