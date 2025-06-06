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

#Domain verification txt records
resource "azurerm_dns_txt_record" "asuid" {
  name = "asuid"
  resource_group_name = var.resourcegroup
  zone_name = azurerm_dns_zone.jacobsazlabdns.name
  ttl = 3600

  record {
    value = "ba2537f4b7e5a24dbc5d16eab3b7178f2210ee967bc110614a3daf46c3e72844"
  }
}

#domain verification txt record#2
resource "azurerm_dns_txt_record" "asuid2" {
  name = "asuid.www"
  resource_group_name = var.resourcegroup
  zone_name = azurerm_dns_zone.jacobsazlabdns.name
  ttl = 3600

  record {
    value = "ba2537f4b7e5a24dbc5d16eab3b7178f2210ee967bc110614a3daf46c3e72844"
  }
}