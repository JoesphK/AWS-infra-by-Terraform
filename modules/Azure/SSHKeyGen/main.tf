resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_ssh_public_key" "generated_ssh_key" {
  name                = var.key_name
  resource_group_name = var.resource_group_name
  location            = var.location
  public_key          = tls_private_key.ssh_key.public_key_openssh

  tags = var.tags
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0600"
}

resource "local_file" "public_key_openssh" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "${path.module}/${var.key_name}.pub"
}
