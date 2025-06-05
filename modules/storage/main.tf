resource "azurerm_storage_account" "storageaccount" {
  resource_group_name = var.resourcegroup
  location = var.location
  account_tier = "Standard"
  account_kind = "StorageV2"
  name = var.storageaccount
  account_replication_type = "LRS"
}