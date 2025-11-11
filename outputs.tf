# -----------------------
# OUTPUTS
# -----------------------

/*
# VPC ID 
output "vpc_id" {
  value = module.network.vpc_id
}

# Subnets 
output "public_subnets" {
  value = module.network.public_subnets
}

output "private_subnets" {
  value = module.network.private_subnets
}

*/
#===============================Azure====================
# Azure Outputs

output "azure_resource_group_name" {
  description = "The name of the created Azure Resource Group."
  value       = module.azure_resource_group.name
}

output "azure_resource_group_location" {
  description = "The location of the created Azure Resource Group."
  value       = module.azure_resource_group.resource_group_location
}

output "azure_resource_group_tags" {
  description = "The tags applied to the Azure Resource Group."
  value       = module.azure_resource_group.resource_group_tags
}

