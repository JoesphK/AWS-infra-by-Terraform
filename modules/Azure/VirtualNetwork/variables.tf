variable "name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group where the Virtual Network will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the Virtual Network will be created."
  type        = string
}

variable "address_space" {
  description = "The address space for the Virtual Network."
  type        = list(string)
}

variable "dns_servers" {
  description = "A list of DNS servers to use for the Virtual Network."
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "A list of subnet configurations for the Virtual Network."
  type = list(object({
    name             = string
    address_prefixes = list(string)
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to assign to the Virtual Network. 'WhoMadeThis' will be overridden."
  type        = map(string)
  default     = {}
}

variable "network_encryption_enabled" {
  description = "Whether network encryption is enabled for the Virtual Network."
  type        = bool
  default     = false
}

variable "network_encryption_enforcement" {
  description = "Specifies the enforcement policy for network encryption. Possible values are 'AllowUnencrypted' and 'DropUnencrypted'."
  type        = string
  default     = "AllowUnencrypted"
  validation {
    condition     = contains(["AllowUnencrypted", "DropUnencrypted"], var.network_encryption_enforcement)
    error_message = "The network_encryption_enforcement must be 'AllowUnencrypted' or 'DropUnencrypted'."
  }
}

variable "firewall_enabled" {
  description = "Whether to include a placeholder subnet for Azure Firewall."
  type        = bool
  default     = false
}

variable "bastion_enabled" {
  description = "Enable or disable a placeholder for an Azure Bastion subnet."
  type        = bool
  default     = false
}

variable "ddos_protection_plan_id" {
  description = "The ID of a DDoS Protection Plan to associate with the Virtual Network."
  type        = string
  default     = null
}
