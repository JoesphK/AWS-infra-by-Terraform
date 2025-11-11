variable "vm_name" {
  description = "The name of the Virtual Machine."
  type        = string
}

variable "location" {
  description = "The Azure region where the Virtual Machine will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Virtual Machine will be created."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to which the Virtual Machine's network interface will be attached."
  type        = string
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP address to the VM."
  type        = bool
  default     = false
}

variable "os_type" {
  description = "The OS type of the Virtual Machine (Linux or Windows)."
  type        = string
  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "The os_type must be 'Linux' or 'Windows'."
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
  description = "The size of the Virtual Machine."
  type        = string
}

variable "admin_username" {
  description = "The administrator username for the Virtual Machine."
  type        = string
}

variable "admin_password" {
  description = "The administrator password for Windows Virtual Machines, or for Linux Virtual Machines if no SSH key is provided."
  type        = string
  default     = "" # Default to empty, as it's not always required.
  sensitive   = true
}

variable "ssh_key_name" {
  description = "The name of an *existing* Azure SSH Public Key resource for Linux Virtual Machines. If empty, password authentication will be enabled (if os_type is Linux)."
  type        = string
  default     = ""
}

variable "inbound_ports" {
  description = "A list of inbound ports to allow on the VM's Network Security Group."
  type        = list(number)
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
