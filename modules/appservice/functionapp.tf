#functionapp service plan
resource azurerm_service_plan "FunctionAppServicePlanerviceplan" {
  name                = "FunctionAppServicePlan"
  location            = var.location
  resource_group_name = var.functionsrg
  os_type             = "Linux"
  sku_name            = "Y1" 

  tags = {
    env = "prod"
  }
}

# Function App for Highscore
resource "azurerm_linux_function_app" "highscore_function_app" {
  name                = "highscore-function-app"
  location            = var.location
  resource_group_name = var.functionsrg
  service_plan_id     = azurerm_service_plan.FunctionAppServicePlanerviceplan.id 
  https_only          = true
  storage_account_name = var.storageaccountname
  storage_uses_managed_identity = true
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "STORAGE_ACCOUNT_NAME" = "jacobsazlabstorage2"
    "TABLE_NAME" = "highscores"
    "APPLICATIONINSIGHTS_ROLE_NAME" = "highscore-function-app"
    }
  
  identity {
    type = "SystemAssigned"
  }  
    site_config {
        minimum_tls_version = "1.2"
        application_stack {
         python_version = "3.10" 
        }
    }
}

#assign role to function app to access storage account
resource "azurerm_role_assignment" "func_table_access" {
  principal_id   = azurerm_linux_function_app.highscore_function_app.identity[0].principal_id
  scope          = var.storageaccountid
  role_definition_name = "Storage Table Data Contributor"
  
}


#Create app insights for function app
resource "azurerm_application_insights" "function_app_insights" {
  name                = "function-app-insights"
  location            = var.location
  resource_group_name = var.functionsrg
  application_type    = "web"

  tags = {
    env = "prod"
  }
}