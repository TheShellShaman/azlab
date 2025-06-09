output "storageaccountid" {
  value = azurerm_storage_account.storageaccount.id
}

output "storageaccountname" {
  value = azurerm_storage_account.storageaccount.name
}

output "highscorestablename" {
  value = azurerm_storage_table.highscores.name
}