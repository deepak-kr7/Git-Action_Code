output "resource_group_name" {
  description = "Created Resource Group ka name"
  value       = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  description = "Created Storage Account ka name"
  value       = azurerm_storage_account.storage.name
}

output "vnet_name" {
  description = "Created Virtual Network ka name"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  description = "Created Virtual Network ki ID"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_id" {
  description = "Created Subnet ki ID"
  value       = azurerm_subnet.subnet.id
}
