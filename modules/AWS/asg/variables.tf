variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for launch template"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_ids" {
  description = "List of subnet IDs for ASG"
  type        = list(string)
}

variable "sg_ids" {
  description = "Security group IDs"
  type        = list(string)
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 2
}
