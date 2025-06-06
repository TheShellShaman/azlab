output "production-subnet" {
  value = azurerm_subnet.subnet.id

}

output "appservice_subnet" {
  value = azurerm_subnet.appservice-subnet.id
}

output "vnet" {
  value = azurerm_virtual_network.vnet
}