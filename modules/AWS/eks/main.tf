locals {
  built_access_entries = length(var.eks_access_entries) > 0 ? {
    for idx, e in var.eks_access_entries :
    "entry_${idx}" => {
      principal_arn       = e.principal_arn
      kubernetes_groups   = lookup(e, "kubernetes_groups", [])
      kubernetes_username = lookup(e, "kubernetes_username", null)
      policy_associations = lookup(e, "access_policy_arn", null) != null ? {
        assoc = {
          policy_arn   = e.access_policy_arn
          access_scope = { type = "cluster" }
        }
      } : {}
    }
  } : {}
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.3.2"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version
  endpoint_public_access = true
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids

  eks_managed_node_groups = {
    default = {
      name           = var.node_group_name
      instance_types = var.instance_types
      desired_size   = var.desired_size
      min_size       = var.min_size
      max_size       = var.max_size
      iam_role_arn   = var.node_role_arn != "" ? var.node_role_arn : null
      subnet_ids     = var.subnet_ids
    }
  }

  # Addons in the new format
addons = {
  "vpc-cni" = {
    service_account_role_arn = aws_iam_role.vpc_cni.arn
  },
  "kube-proxy" = {
    version = "v1.27.1"
  },
  "coredns" = {
    version = "v1.12.0"
    configuration_values = length(var.coredns_config) > 0 ? jsonencode(var.coredns_config) : null
    resolve_conflicts_on_create = "OVERWRITE"
  }
}


  access_entries = local.built_access_entries

  enable_irsa = var.enable_irsa
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions
  tags = var.tags
}
# -----------------------
# IAM Role for VPC CNI
# -----------------------
resource "aws_iam_role" "vpc_cni" {
  name = "${var.cluster_name}-vpc-cni"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = module.eks.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          "StringEquals" = {
            "${module.eks.oidc_provider}:sub" = "system:serviceaccount:kube-system:aws-node"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vpc_cni" {
  role       = aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
