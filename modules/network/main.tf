#Production Vnet
resource "azurerm_virtual_network" "vnet" {
  name = var.production-vnet
  resource_group_name = var.resourcegroup
  location = var.location
  address_space = [ "10.0.0.0/16" ]
  tags = {
    env = "prod"
  }
}

#Production Subnet
resource "azurerm_subnet" "subnet" {
  name = var.production-subnet
  resource_group_name = var.resourcegroup
  virtual_network_name = var.production-vnet
  address_prefixes = ["10.0.1.0/24"]

}

resource "azurerm_subnet" "appservice-subnet" {
  name = var.appservice-subnet
  resource_group_name = var.resourcegroup
  virtual_network_name = var.production-vnet
  address_prefixes = [ "10.0.2.0/24" ]
}