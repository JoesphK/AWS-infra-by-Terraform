# Data source to fetch existing SSH Public Key
data "azurerm_ssh_public_key" "existing_ssh_key" {
  count               = var.os_type == "Linux" && var.ssh_key_name != "" ? 1 : 0
  name                = var.ssh_key_name
  resource_group_name = var.resource_group_name # Assuming SSH key is in the same RG as VM
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.assign_public_ip ? azurerm_public_ip.vm_public_ip[0].id : null
  }

  tags = var.tags
}

resource "azurerm_public_ip" "vm_public_ip" {
  count               = var.assign_public_ip ? 1 : 0
  name                = "${var.vm_name}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"

  tags = var.tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vm_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "inbound_ssh" {
  # Allow SSH only for Linux VMs if port 22 is in inbound_ports
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
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "inbound_rdp" {
  # Allow RDP only for Windows VMs if port 3389 is in inbound_ports
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
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "inbound_http" {
  # Allow HTTP for both OS types if port 80 is in inbound_ports
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
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "inbound_https" {
  # Allow HTTPS for both OS types if port 443 is in inbound_ports
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
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  count                 = var.os_type == "Linux" ? 1 : 0
  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]
  zone                 = "1"

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

  # Use admin_ssh_key block for SSH configuration if ssh_key_name is provided
  dynamic "admin_ssh_key" {
    for_each = var.ssh_key_name != "" ? [1] : []
    content {
      username   = var.admin_username
      public_key = data.azurerm_ssh_public_key.existing_ssh_key[0].public_key
    }
  }

  # Disable password authentication for Linux VMs when using SSH keys
  disable_password_authentication = var.ssh_key_name != "" ? true : false

  # Conditionally set admin_password for Linux if no SSH key is provided
  # This is only allowed if disable_password_authentication is false
  admin_password = var.ssh_key_name == "" ? var.admin_password : null

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  count                 = var.os_type == "Windows" ? 1 : 0
  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]
  zone              = "1"

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

  tags = var.tags
}
