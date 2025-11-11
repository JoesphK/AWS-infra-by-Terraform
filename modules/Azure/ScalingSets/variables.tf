variable "vmss_name" {
  description = "The name of the Virtual Machine Scale Set."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the VMSS will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the VMSS will be created."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to which the VMSS instances will be connected."
  type        = string
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP to the VMSS instances."
  type        = bool
  default     = true
}

variable "os_type" {
  description = "The operating system type of the VMSS instances (Linux or Windows)."
  type        = string
  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "The os_type must be either 'Linux' or 'Windows'."
  }
}

variable "vm_image_publisher" {
  description = "The publisher of the VM image."
  type        = string
}

variable "vm_image_offer" {
  description = "The offer of the VM image."
  type        = string
}

variable "vm_image_sku" {
  description = "The SKU of the VM image."
  type        = string
}

variable "vm_image_version" {
  description = "The version of the VM image."
  type        = string
  default     = "latest"
}

variable "vm_size" {
  description = "The size of the Virtual Machine Scale Set instances."
  type        = string
}

variable "admin_username" {
  description = "The administrator username for the VMSS instances."
  type        = string
}

variable "admin_password" {
  description = "The administrator password for Windows VMSS instances. Required if os_type is Windows."
  type        = string
  default     = null
}

variable "ssh_key_name" {
  description = "The name of an *existing* Azure SSH Public Key resource for Linux VMSS instances. If empty, password authentication will be enabled."
  type        = string
  default     = null
}

variable "ssh_public_key_content" {
  description = "The content of an SSH public key to use for Linux VMSS instances. Overrides ssh_key_name if provided."
  type        = string
  default     = null
  sensitive   = true
}

variable "generated_ssh_public_key_content" {
  description = "The public key content to use for Linux VMSS instances. If provided, this will be used instead of looking up an existing key by name."
  type        = string
  default     = null # Set to null by default, meaning it's optional
  sensitive   = true
}

variable "min_instance_count" {
  description = "The minimum number of instances in the VMSS."
  type        = number
  default     = 2
}

variable "max_instance_count" {
  description = "The maximum number of instances in the VMSS."
  type        = number
  default     = 4
}

variable "autoscale_policy_name" {
  description = "The name of the autoscale policy."
  type        = string
  default     = "default-autoscale-policy"
}

variable "tags" {
  description = "A map of tags to add to the resources."
  type        = map(string)
  default     = {}
}

variable "inbound_ports" {
  description = "A list of inbound ports to allow on the VMSS Network Security Group."
  type        = list(number)
  default     = []
}
