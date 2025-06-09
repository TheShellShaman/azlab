#Private DNS Zone for Production
resource "azurerm_private_dns_zone" "production_dns" {
  name                = "jacobsazlab.com"
  resource_group_name = var.resourcegroup
  tags = {
    env = "prod"
  }
}

