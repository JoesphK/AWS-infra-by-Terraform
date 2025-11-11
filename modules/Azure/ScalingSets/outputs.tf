output "vmss_name" {
  description = "The name of the created Virtual Machine Scale Set."
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine_scale_set.linux_vmss[0].name : azurerm_windows_virtual_machine_scale_set.windows_vmss[0].name
}

output "vmss_id" {
  description = "The ID of the created Virtual Machine Scale Set."
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine_scale_set.linux_vmss[0].id : azurerm_windows_virtual_machine_scale_set.windows_vmss[0].id
}

output "public_ip_id" {
  description = "The ID of the Public IP address associated with the Load Balancer (if assigned)."
  value       = var.assign_public_ip ? azurerm_public_ip.vmss_public_ip[0].id : null
}

output "load_balancer_id" {
  description = "The ID of the Load Balancer (if assigned)."
  value       = var.assign_public_ip ? azurerm_lb.vmss_lb[0].id : null
}

output "network_security_group_id" {
  description = "The ID of the Network Security Group associated with the VMSS."
  value       = azurerm_network_security_group.vmss_nsg.id
}

output "autoscale_setting_id" {
  description = "The ID of the Autoscale Setting for the VMSS."
  value       = azurerm_monitor_autoscale_setting.vmss_autoscale.id
}