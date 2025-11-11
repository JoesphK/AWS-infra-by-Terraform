output "name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name # Assuming your resource group is named 'rg' in main.tf
}

output "resource_group_location" {
  description = "The location of the created Azure Resource Group."
  value       = azurerm_resource_group.rg.location
}

output "resource_group_tags" {
  description = "The tags applied to the Azure Resource Group."
  value       = azurerm_resource_group.rg.tags
}
