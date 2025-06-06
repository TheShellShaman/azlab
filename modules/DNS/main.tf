resource "azurerm_dns_zone" "jacobsazlabdns" {
  name = "jacobsazlab.com"
  resource_group_name = var.resourcegroup
  tags = {
    "env" = "prod"
  }
}