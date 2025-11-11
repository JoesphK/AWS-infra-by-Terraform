output "ssh_public_key_name" {
  description = "The name of the generated SSH public key in Azure."
  value       = azurerm_ssh_public_key.generated_ssh_key.name
}

output "ssh_public_key_content" {
  description = "The OpenSSH public key content."
  value       = tls_private_key.ssh_key.public_key_openssh
  sensitive   = true
}

output "ssh_private_key_pem" {
  description = "The private key in PEM format (saved locally)."
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}
