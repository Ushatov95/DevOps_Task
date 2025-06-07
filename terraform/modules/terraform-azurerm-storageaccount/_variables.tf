variable "name" {
  description = "Name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where to create the storage account"
  type        = string
}

variable "location" {
  description = "Location where the storage account will be created"
  type        = string
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account"
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = null
}