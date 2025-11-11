variable "instances" {
  description = "Map of instances to create"
  type = map(object({
    ami_id        = string      # Custom AMI ID
    instance_type = string
    subnet_id     = string
    sg_ids        = list(string)
  }))
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
