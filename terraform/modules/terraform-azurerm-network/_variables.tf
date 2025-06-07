variable "resource_group_name" {
  description = "Name of the resource group in which the virtual network will be created"
  type = string
}

variable "location" {
  description = "Location where the virtual network will be created"
  type = string
}

variable "name" {
  description = "Name of the virtual network"
  type = string
}

variable "cidr" {
  description = "CIDR block for the virtual network"
  type = string
}

variable "subnets" {
  description = "List of subnets in the virtual network"
  type = map(object({
    name = string
    address_prefix = string
  }))
  default = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type = map(any)
  default = null
}