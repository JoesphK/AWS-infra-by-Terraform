output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "cluster_oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "node_group_names" {
  value = keys(module.eks.eks_managed_node_groups)
}

output "node_group_role_arns" {
  value = { for ng, obj in module.eks.eks_managed_node_groups : ng => obj.iam_role_arn }
}
