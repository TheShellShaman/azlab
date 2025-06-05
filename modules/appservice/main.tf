#Appserviceplan (linux)
resource "azurerm_service_plan" "appserviceplan" {
  name = "WebServicePlan"
  location = var.location
  resource_group_name = var.resourcegroup
  os_type = "Linux"
  sku_name = "B1"

  tags = {
    "env" = "prod"
  }
}

#Appservice
resource "azurerm_linux_web_app" "linuxwebapp" {
  name = "linuxwebapp"
  location = var.location
  resource_group_name = var.resourcegroup
  service_plan_id = azurerm_service_plan.appserviceplan.id
  https_only = true
  

    identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true
    minimum_tls_version = "1.2" 
  }
}

