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
    "STORAGE_ACCOUNT_NAME" = "var.storageaccountname"
    "TABLE_NAME" = var.highscorestablename
    }
  
  identity {
    type = "SystemAssigned"
  }  
    site_config {
        minimum_tls_version = "1.2"
        application_stack {
         python_version = "3.11" 
        }
    }
}