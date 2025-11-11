variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "assume_services" {
  description = "List of AWS services allowed to assume this role"
  type        = list(string)
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the role"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to the IAM role"
  type        = map(string)
  default     = {}
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile for the role (for EKS NodeGroups)"
  type        = bool
  default     = false
}
