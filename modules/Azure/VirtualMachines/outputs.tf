output "vm_name" {
  description = "The name of the created Virtual Machine."
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine.linux_vm[0].name : azurerm_windows_virtual_machine.windows_vm[0].name
}

output "public_ip_address" {
  description = "The public IP address of the Virtual Machine, if assigned."
  value       = var.assign_public_ip ? azurerm_public_ip.vm_public_ip[0].ip_address : null
}

output "network_interface_id" {
  description = "The ID of the network interface attached to the VM."
  value       = azurerm_network_interface.nic.id
}

output "network_security_group_id" {
  description = "The ID of the Network Security Group associated with the VM."
  value       = azurerm_network_security_group.nsg.id
}
