terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Configure the Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "cad7b110-5cb4-433d-93fa-6db3d35b8a98" # Replace with the actual subscription ID you copied
}

# Call the Azure Resource Group module
module "azure_resource_group" {
  source = "./modules/Azure/ResourceGroup"

  resource_group_name = var.azure_resource_group_name
  location            = var.azure_location
  tags                = var.azure_tags
}

# Call the Azure Virtual Network module
module "azure_virtual_network" {
  source = "./modules/Azure/VirtualNetwork"

  name                = var.azure_vnet_name
  location            = var.azure_location
  resource_group_name = module.azure_resource_group.name
  address_space       = var.azure_vnet_address_space
  subnets             = var.azure_vnet_subnets
  tags                = var.azure_tags
}

# Call the Azure SSH Key Generation module
module "azure_ssh_key_gen" {
  source = "./modules/Azure/SSHKeyGen"

  key_name            = var.azure_ssh_key_name_to_generate
  resource_group_name = module.azure_resource_group.name
  location            = var.azure_location
  tags                = var.azure_tags
}

# Call the Azure Virtual Machine Scale Set module
module "azure_scaling_sets" {
  source = "./modules/Azure/ScalingSets"

  resource_group_name = module.azure_resource_group.name
  location            = var.azure_location
  vmss_name           = var.azure_vmss_name
  subnet_id           = module.azure_virtual_network.subnet_ids[0] # Assuming the first subnet
  assign_public_ip    = var.azure_vmss_assign_public_ip
  os_type             = var.azure_vmss_os_type
  vm_image_publisher  = var.azure_vmss_image_publisher
  vm_image_offer      = var.azure_vmss_image_offer
  vm_image_sku        = var.azure_vmss_image_sku
  vm_image_version    = var.azure_vmss_image_version
  vm_size             = var.azure_vmss_size
  admin_username      = var.azure_vmss_admin_username
  admin_password      = var.azure_vmss_admin_password
  inbound_ports       = var.azure_vmss_inbound_ports
  min_instance_count  = var.azure_vmss_min_instance_count
  max_instance_count  = var.azure_vmss_max_instance_count
  tags                = var.azure_tags

  # Ensure existing key name is not passed if we want to use the generated one
  ssh_key_name = "" # Explicitly set to empty to ensure generated key is used
}