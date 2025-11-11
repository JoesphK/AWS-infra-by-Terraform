output "virtual_network_name" {
  description = "The name of the created Virtual Network."
  value       = azurerm_virtual_network.vnet.name
}

output "virtual_network_id" {
  description = "The ID of the created Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "virtual_network_location" {
  description = "The location of the Virtual Network."
  value       = azurerm_virtual_network.vnet.location
}

output "virtual_network_address_space" {
  description = "The address space of the Virtual Network."
  value       = azurerm_virtual_network.vnet.address_space
}

output "virtual_network_tags" {
  description = "The tags assigned to the Virtual Network."
  value       = azurerm_virtual_network.vnet.tags
}

output "subnet_ids" {
  description = "A list of IDs of the created subnets."
  value       = [for s in azurerm_subnet.subnets : s.id]
}


