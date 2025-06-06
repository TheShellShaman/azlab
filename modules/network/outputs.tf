output "production-subnet" {
  value = azurerm_subnet.subnet.id

}

output "appservice-subnet" {
  value = azurerm_subnet.appservice-subnet
}