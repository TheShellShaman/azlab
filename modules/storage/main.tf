#Web Storage Account
resource "azurerm_storage_account" "storageaccount" {
  resource_group_name = var.resourcegroup
  location = var.location
  account_tier = "Standard"
  account_kind = "StorageV2"
  name = var.storageaccount
  account_replication_type = "LRS"
  public_network_access_enabled = false
  tags = {
    env = "prod"
  }
}

#web storage account rules
resource "azurerm_storage_account_network_rules" "storageaccountrules" {
  storage_account_id = azurerm_storage_account.storageaccount.id
  default_action = "Allow"
  bypass = [  ]
  virtual_network_subnet_ids = [var.appservice_subnet]
  ip_rules = ["135.135.180.231"]
}

#storage endpoint
resource "azurerm_private_endpoint" "storage-endpoint" {
  name = "storage-endpoint"
  resource_group_name = var.resourcegroup
  location = var.location 
  subnet_id = var.production-subnet

  #connection to the storage account
  private_service_connection {
    name = "Connection-to-storageaccount"
    is_manual_connection = false
    subresource_names = ["blob","file"]
    private_connection_resource_id = azurerm_storage_account.storageaccount.id
  }
  tags = {
    env = "prod"
  }
  
}

#Container for tfstate
resource "azurerm_storage_container" "tfstatecontainer" {
  name = "tfstate"
  storage_account_name = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}