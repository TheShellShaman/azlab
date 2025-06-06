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
  name = "jacobsazlabwebapp"
  location = var.location
  resource_group_name = var.resourcegroup
  service_plan_id = azurerm_service_plan.appserviceplan.id
  https_only = true
  virtual_network_subnet_id = var.appservice_subnet

    identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true
    minimum_tls_version = "1.2" 
  }
}

resource "azurerm_role_assignment" "app-to-blob-access" {
  principal_id = azurerm_linux_web_app.linuxwebapp.identity[0].principal_id
  scope = var.storageaccountid
  role_definition_name = "Storage Blob Data Reader"
}

