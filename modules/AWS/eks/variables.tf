variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "node_group_name" {
  type = string
}

variable "instance_types" {
  type = list(string)
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

# single declaration only
variable "node_role_arn" {
  description = "Optional: pre-existing IAM role ARN to use for managed node groups (iam_role_arn)"
  type        = string
  default     = ""
}

variable "tags" {
  type = map(string)
  default = {}
}
# allow passing cluster_addons from root into the upstream module
variable "cluster_addons" {
  description = "Map of addon configs passed to terraform-aws-modules/eks/aws"
  type        = map(any)
  default     = {}
}

# list of access entries (optional)
variable "eks_access_entries" {
  description = "List of access entry objects: principal_arn, kubernetes_groups, kubernetes_username, access_policy_arn"
  type = list(object({
    principal_arn       = string
    kubernetes_groups   = optional(list(string), [])
    kubernetes_username = optional(string, null)
    access_policy_arn   = optional(string, null)
  }))
  default = []
}

# IRSA toggle (OIDC)
variable "enable_irsa" {
  type    = bool
  default = true
}

# Control creator admin behavior
variable "enable_cluster_creator_admin_permissions" {
  type    = bool
  default = true
}

# optional CoreDNS config (map) to be JSON-encoded and passed to the addon
variable "coredns_config" {
  description = "Optional CoreDNS configuration map"
  type        = map(any)
  default     = {}
}