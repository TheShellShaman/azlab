resource "azurerm_dns_zone" "jacobsazlabdns" {
  name = "jacobsazlab.com"
  resource_group_name = var.resourcegroup
  tags = {
    "env" = "prod"
  }
}

resource "azurerm_dns_cname_record" "webapp_cname" {
  name = "www"
  zone_name = azurerm_dns_zone.jacobsazlabdns.name
  resource_group_name = var.resourcegroup
  ttl = 3600
  record = "jacobsazlabwebapp.azurewebsites.net"
}

resource "azurerm_dns_a_record" "webapp_root" {
  name = "@"
  zone_name = azurerm_dns_zone.jacobsazlabdns.name
  resource_group_name = var.resourcegroup
  ttl = 3600
  records = [ 
    "40.89.248.186",
    "40.89.249.225",
    "40.89.250.33",
    "40.89.250.126",
    "40.89.251.18",
    "40.89.251.37",
    "20.40.202.25"
   ]
}

