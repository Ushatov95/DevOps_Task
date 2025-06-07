variable "location" {
  description = "Location where the resource group should be created"
  type = string
}

variable "name" {
  description = "Name of the resource group"
  type = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type = map(any)
  default = null
}