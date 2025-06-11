#Web Storage Account
resource "azurerm_storage_account" "storageaccount" {
  resource_group_name = var.resourcegroup
  location = var.location
  account_tier = "Standard"
  account_kind = "StorageV2"
  name = var.storageaccount
  account_replication_type = "LRS"
  public_network_access_enabled = true
  tags = {
    env = "prod"
  }
}

#web storage account rules
resource "azurerm_storage_account_network_rules" "storageaccountrules" {
  storage_account_id = azurerm_storage_account.storageaccount.id
  default_action = "Allow"
  bypass = ["AzureServices"]
  virtual_network_subnet_ids = [var.appservice_subnet]
  ip_rules = ["135.135.180.231"]
}

#web storage endpoint
resource "azurerm_private_endpoint" "storage-endpoint" {
  name = "storage-endpoint"
  resource_group_name = var.resourcegroup
  location = var.location 
  subnet_id = var.production-subnet

  #connection to the storage account
  private_service_connection {
    name = "Connection-to-storageaccount"
    is_manual_connection = false
    subresource_names = ["blob"]
    private_connection_resource_id = azurerm_storage_account.storageaccount.id
  }
  tags = {
    env = "prod"
  }
  
}

#Container for tfstate
resource "azurerm_storage_container" "tfstatecontainer" {
  name = "tfstate"
  storage_account_name = azurerm_storage_account.tfstorage.name
  container_access_type = "private"
}

#TFSTORAGE account
resource "azurerm_storage_account" "tfstorage" {
  name = "tfstoragejacobslab"
  resource_group_name = var.resourcegroup
  location = var.location
  account_replication_type = "LRS"
  account_tier = "Standard"
  account_kind = "StorageV2"
}

#tfstorage account net rules
resource "azurerm_storage_account_network_rules" "tfstoragenetrules" {
  storage_account_id = azurerm_storage_account.tfstorage.id
  default_action = "Allow"
  ip_rules = ["135.135.180.231"]
}


#functionapp storage account
resource "azurerm_storage_account" "functionappstorage" {
  name = "functionappstoragejacobslab"
  resource_group_name = var.functionsrg
  location = var.location
  account_replication_type = "LRS"
  account_tier = "Standard"
  account_kind = "StorageV2"
}

#functionapp storage account network rules
resource "azurerm_storage_account_network_rules" "functionappstoragenetrules" {
  storage_account_id = azurerm_storage_account.functionappstorage.id
  default_action = "Allow"
  bypass = ["AzureServices"]
}

#functionsstorage account table for highscores
resource "azurerm_storage_table" "highscores" {
  name = "highscores"
  storage_account_name = azurerm_storage_account.functionappstorage.name
}