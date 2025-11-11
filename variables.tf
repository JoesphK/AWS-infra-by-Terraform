# Provider / region
variable "region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

# Network
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDRs"
  default     = ["10.1.10.0/24", "10.1.11.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDRs"
  default     = ["10.1.12.0/24", "10.1.13.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones for subnets"
  default     = ["us-east-1a", "us-east-1b"]
}

# Key pair
variable "key_name" {
  type        = string
  description = "Name of the AWS key pair (not the .pem file path)"
  default     = "SKYoussefKey"
}

# EC2 instances
variable "ec2_amis" {
  description = "Map (name => ami) for EC2 instances. Terraform will create one EC2 per key."
  type        = map(string)
  default     = {}
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type for instances"
  default     = "t3.small"
}

# Security group inputs
variable "instance_sg_name" {
  type        = string
  description = "Name for the instance security group"
  default     = "instance-sg"
}

variable "instance_sg_description" {
  type        = string
  description = "Description for the instance security group"
  default     = "Instance SG (SSH/HTTP/etc.)"
}


variable "eks_nodes_ingress_rules" {
  description = "Ingress rules for EKS node security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}

variable "instance_egress_rules" {
  description = "Egress rules for security groups"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}


# Generic tags
variable "tags" {
  type    = map(string)
  default = {}
}

# Optional ASG variables (kept for later)
variable "asg_name" {
  type    = string
  default = "wordpress-youssef"
}

variable "asg_ami" {
  type    = string
  default = ""
}

variable "asg_instance_type" {
  type    = string
  default = "t3.small"
}

variable "asg_desired_capacity" {
  type    = number
  default = 1
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 3
}



variable "eks_cluster_iam" {
  description = "IAM configuration for the EKS cluster role"
  type = object({
    role_name           = string
    assume_services     = list(string)
    managed_policy_arns = list(string)
    tags                = optional(map(string), {})
  })
}

variable "eks_node_iam" {
  description = "IAM configuration for the EKS node role"
  type = object({
    role_name           = string
    assume_services     = list(string)
    managed_policy_arns = list(string)
    tags                = optional(map(string), {})
  })
}

variable "cluster_name" {
  type    = string
  default = "sk-eks-cluster"
}

variable "cluster_version" {
  type    = string
  default = "1.30"
}

variable "node_group_name" {
  type    = string
  default = "sk-node-group"
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "desired_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}
variable "node_role_arn" {
  description = "Optional: ARN of the IAM role for EKS nodes. If empty, uses module.eks_node_role.role_arn."
  type        = string
  default     = ""
}

variable "admin_iam_user" {
  description = "IAM user ARN to grant admin access to the cluster"
  type        = string
}

# Addons & cluster settings
variable "cluster_enabled_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# Access entries to map IAM principals -> kubernetes groups & policy association
# Example structure in terraform.tfvars:
# eks_access_entries = [
#   { principal_arn = "arn:aws:iam::123:role/my-admin" , groups = ["system:masters"], policy = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy" }
# ]
variable "eks_access_entries" {
  type = list(object({
    principal_arn       = string
    kubernetes_groups   = optional(list(string), [])
    kubernetes_username = optional(string, null)
    access_policy_arn   = optional(string, null)
  }))
  default = []
}

# Addon config for CoreDNS if you want (optional)
variable "coredns_config" {
  type    = map(any)
  default = {}
}

#==============================================Azure==========================
# Azure Variables
variable "azure_resource_group_name" {
  description = "Name of the Azure Resource Group."
  type        = string
  default     = "Youssef-rg"
}

variable "azure_location" {
  description = "Azure region for the Resource Group."
  type        = string
  default     = "East US"
}

variable "azure_tags" {
  description = "Tags to apply to the Azure Resource Group."
  type        = map(string)
  default = {
    WhomadeThis = "Youssef"
  }
}

variable "azure_vnet_name" {
  description = "Name of the Azure Virtual Network"
  type        = string
  default     = "Youssef-Network"
}

variable "azure_vnet_address_space" {
  description = "The address space for the Azure Virtual Network."
  type        = list(string)
  default     = ["10.1.0.0/16"] # Ensure this is a broad enough range for your subnets
}

variable "azure_vnet_subnets" {
  description = "A list of subnet configurations for the Azure Virtual Network."
  type = list(object({
    name             = string
    address_prefixes = list(string)
  }))
  default = [
    {
      name             = "web-subnet"
      address_prefixes = ["10.1.1.0/24"] # First subnet
    },
    {
      name             = "app-subnet"
      address_prefixes = ["10.1.2.0/24"] # Second subnet
    },
    # You can add more subnets here if needed
  ]
}

# Azure Virtual Machine Variables
variable "azure_vm_name" {
  description = "The name of the Azure Virtual Machine."
  type        = string
  default     = "my-terraform-vm"
}

variable "azure_vm_assign_public_ip" {
  description = "Whether to assign a public IP address to the VM."
  type        = bool
  default     = true
}

variable "azure_vm_os_type" {
  description = "The OS type of the Virtual Machine (Linux or Windows)."
  type        = string
  default     = "Linux" # or "Windows"
  validation {
    condition     = contains(["Linux", "Windows"], var.azure_vm_os_type)
    error_message = "The azure_vm_os_type must be 'Linux' or 'Windows'."
  }
}

variable "azure_vm_image_publisher" {
  description = "The publisher of the VM image."
  type        = string
  default     = "Canonical" # For Ubuntu: "Canonical", For Windows: "MicrosoftWindowsServer"
}

variable "azure_vm_image_offer" {
  description = "The offer of the VM image."
  type        = string
  default     = "0001-com-ubuntu-server-jammy" # For Ubuntu 22.04: "0001-com-ubuntu-server-jammy", For Windows: "WindowsServer"
}

variable "azure_vm_image_sku" {
  description = "The SKU of the VM image."
  type        = string
  default     = "22_04-lts-gen2" # For Ubuntu 22.04: "22_04-lts-gen2", For Windows: "2019-Datacenter"
}

variable "azure_vm_image_version" {
  description = "The version of the VM image."
  type        = string
  default     = "latest"
}

variable "azure_vm_size" {
  description = "The size of the Virtual Machine."
  type        = string
  default     = "Standard_B2s"
}

variable "azure_vm_admin_username" {
  description = "The administrator username for the Virtual Machine."
  type        = string
  default     = "azureuser"
}

variable "azure_vm_admin_password" {
  description = "The administrator password for Windows Virtual Machines, or for Linux Virtual Machines if no SSH key is provided. Required in these cases."
  type        = string
  default     = "GBGAcademy!" # Changed default to empty, as it's not always required.
  sensitive   = true
}

variable "azure_vm_ssh_key_name" {
  description = "The name of an *existing* Azure SSH Public Key resource for Linux Virtual Machines. If empty, password authentication will be enabled (if os_type is Linux)."
  type        = string
  default     = "YoussefAzureKey" # Default to empty, meaning no existing SSH key is used by default
}

variable "azure_vm_inbound_ports" {
  description = "A list of inbound ports to allow on the VM's Network Security Group."
  type        = list(number)
  default     = [22, 80, 443] # Default for Linux: SSH, HTTP, HTTPS. For Windows: RDP, HTTP, HTTPS.
}

# Azure Virtual Machine Scale Set Variables
variable "azure_vmss_name" {
  description = "The name of the Azure Virtual Machine Scale Set."
  type        = string
  default     = "youssef-vmss"
}

variable "azure_vmss_assign_public_ip" {
  description = "Whether to assign a public IP address to the VMSS Load Balancer."
  type        = bool
  default     = true
}

variable "azure_vmss_os_type" {
  description = "The OS type of the Virtual Machine Scale Set instances (Linux or Windows)."
  type        = string
  default     = "Linux" # or "Windows"
  validation {
    condition     = contains(["Linux", "Windows"], var.azure_vmss_os_type)
    error_message = "The azure_vmss_os_type must be 'Linux' or 'Windows'."
  }
}

variable "azure_vmss_image_publisher" {
  description = "The publisher of the VMSS image."
  type        = string
  default     = "Canonical" # For Ubuntu: "Canonical", For Windows: "MicrosoftWindowsServer"
}

variable "azure_vmss_image_offer" {
  description = "The offer of the VMSS image."
  type        = string
  default     = "0001-com-ubuntu-server-jammy" # For Ubuntu 22.04: "0001-com-ubuntu-server-jammy", For Windows: "WindowsServer"
}

variable "azure_vmss_image_sku" {
  description = "The SKU of the VMSS image."
  type        = string
  default     = "22_04-lts-gen2" # For Ubuntu 22.04: "22_04-lts-gen2", For Windows: "2019-Datacenter"
}

variable "azure_vmss_image_version" {
  description = "The version of the VMSS image."
  type        = string
  default     = "latest"
}

variable "azure_vmss_size" {
  description = "The size of the Virtual Machine Scale Set instances."
  type        = string
  default     = "Standard_B1ms"
}

variable "azure_vmss_admin_username" {
  description = "The administrator username for the Virtual Machine Scale Set instances."
  type        = string
  default     = "azureuser"
}

variable "azure_vmss_admin_password" {
  description = "The administrator password for Windows VMSS instances, or for Linux VMSS instances if no SSH key is provided. Required in these cases."
  type        = string
  default     = "GBGAcademy!" # Changed default to empty, as it's not always required.
  sensitive   = true
}

variable "azure_vmss_ssh_key_name" {
  description = "The name of an *existing* Azure SSH Public Key resource for Linux VMSS instances. If empty, the generated key will be used."
  type        = string
  default     = "" # <--- Ensure this is empty to use the generated key
}

variable "azure_vmss_inbound_ports" {
  description = "A list of inbound ports to allow on the VMSS Network Security Group."
  type        = list(number)
  default     = [22, 80, 443] # <--- Added port 22
}

variable "azure_vmss_min_instance_count" {
  description = "The minimum number of instances in the Virtual Machine Scale Set."
  type        = number
  default     = 2
}

variable "azure_vmss_max_instance_count" {
  description = "The maximum number of instances in the Virtual Machine Scale Set."
  type        = number
  default     = 5
}

variable "azure_ssh_key_name_to_generate" {
  description = "The name for the SSH key to be generated and stored in Azure."
  type        = string
  default     = "YoussefAzureKey"
}