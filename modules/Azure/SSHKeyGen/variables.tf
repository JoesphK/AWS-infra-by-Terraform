variable "key_name" {
  description = "The name of the SSH key to generate and store in Azure."
  type        = string
  default     = "generated-ssh-key"
}

variable "resource_group_name" {
  description = "The name of the resource group where the SSH public key will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the SSH public key will be created."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to the SSH public key resource."
  type        = map(string)
  default     = {}
}
