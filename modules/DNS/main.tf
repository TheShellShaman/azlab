resource "azurerm_dns_zone" "jacobsazlabdns" {
  name = "jacobsazlab"
  resource_group_name = var.resourcegroup
  tags = {
    "env" = "prod"
  }
}