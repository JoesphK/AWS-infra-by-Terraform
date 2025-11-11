# Data source to fetch existing SSH Public Key
# This data source will only be used if generated_ssh_public_key_content is NOT provided
# AND an existing ssh_key_name IS provided.
data "azurerm_ssh_public_key" "existing_ssh_key" {
  count               = var.os_type == "Linux" && var.generated_ssh_public_key_content == null && var.ssh_key_name != "" ? 1 : 0
  name                = var.ssh_key_name
  resource_group_name = var.resource_group_name # Assuming SSH key is in the same RG as VM
}

resource "azurerm_network_security_group" "vmss_nsg" {
  name                = "${var.vmss_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "inbound_ssh" {
  count                       = var.os_type == "Linux" && contains(var.inbound_ports, 22) ? 1 : 0
  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.vmss_nsg.name
}

resource "azurerm_network_security_rule" "inbound_rdp" {
  count                       = var.os_type == "Windows" && contains(var.inbound_ports, 3389) ? 1 : 0
  name                        = "Allow-RDP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.vmss_nsg.name
}

resource "azurerm_network_security_rule" "inbound_http" {
  count                       = contains(var.inbound_ports, 80) ? 1 : 0
  name                        = "Allow-HTTP"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.vmss_nsg.name
}

resource "azurerm_network_security_rule" "inbound_https" {
  count                       = contains(var.inbound_ports, 443) ? 1 : 0
  name                        = "Allow-HTTPS"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.vmss_nsg.name
}

resource "azurerm_linux_virtual_machine_scale_set" "linux_vmss" {
  count                 = var.os_type == "Linux" ? 1 : 0
  name                  = var.vmss_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  sku                   = var.vm_size
  instances             = var.min_instance_count # Initial number of instances
  admin_username        = var.admin_username
  zones                 = ["1"]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  network_interface {
    name    = "${var.vmss_name}-nic"
    primary = true

    ip_configuration {
      name                          = "internal"
      primary                       = true
      subnet_id                     = var.subnet_id
      # Removed load_balancer_backend_address_pool_ids

      # Add public_ip_address_configuration if public IPs are assigned directly
      dynamic "public_ip_address_configuration" {
        for_each = var.assign_public_ip ? [1] : []
        content {
          name = "${var.vmss_name}-publicip"
          sku  = "Standard" # Standard SKU for direct public IPs on VMSS
        }
      }
    }

    network_security_group_id = azurerm_network_security_group.vmss_nsg.id
  }

  # Only include the admin_ssh_key block if an SSH key is actually being used
  dynamic "admin_ssh_key" {
    for_each = (var.generated_ssh_public_key_content != null || var.ssh_key_name != "") ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.generated_ssh_public_key_content != null ? var.generated_ssh_public_key_content : (
                   try(data.azurerm_ssh_public_key.existing_ssh_key[0].public_key, null)
                   )
    }
  }

  # Disable password authentication if any SSH key (generated or existing) is used
  disable_password_authentication = (var.generated_ssh_public_key_content != null || var.ssh_key_name != "") ? true : false

  # Conditionally set admin_password for Linux if no SSH key is provided at all
  admin_password = (var.generated_ssh_public_key_content == null && var.ssh_key_name == "") ? var.admin_password : null

  tags = var.tags
}

resource "azurerm_windows_virtual_machine_scale_set" "windows_vmss" {
  count                 = var.os_type == "Windows" ? 1 : 0
  name                  = var.vmss_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  sku                   = var.vm_size
  instances             = var.min_instance_count # Initial number of instances
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  zones                 = ["1"]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  network_interface {
    name    = "${var.vmss_name}-nic"
    primary = true

    ip_configuration {
      name                          = "internal"
      primary                       = true
      subnet_id                     = var.subnet_id
      # Removed load_balancer_backend_address_pool_ids

      # Add public_ip_address_configuration if public IPs are assigned directly
      dynamic "public_ip_address_configuration" {
        for_each = var.assign_public_ip ? [1] : []
        content {
          name = "${var.vmss_name}-publicip"
          sku  = "Standard" # Standard SKU for direct public IPs on VMSS
        }
      }
    }

    network_security_group_id = azurerm_network_security_group.vmss_nsg.id
  }

  tags = var.tags
}

resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {
  name                = "${var.vmss_name}-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = var.os_type == "Linux" ? azurerm_linux_virtual_machine_scale_set.linux_vmss[0].id : azurerm_windows_virtual_machine_scale_set.windows_vmss[0].id

  profile {
    name = "default"

    capacity {
      default = var.min_instance_count
      minimum = var.min_instance_count
      maximum = var.max_instance_count
    }

    # Rule to scale out
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = var.os_type == "Linux" ? azurerm_linux_virtual_machine_scale_set.linux_vmss[0].id : azurerm_windows_virtual_machine_scale_set.windows_vmss[0].id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M" # Added required time_window
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
    }

    # Rule to scale in
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = var.os_type == "Linux" ? azurerm_linux_virtual_machine_scale_set.linux_vmss[0].id : azurerm_windows_virtual_machine_scale_set.windows_vmss[0].id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M" # Added required time_window
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
    }
  }

  tags = var.tags
}
