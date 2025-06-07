##TODO: Remove tenant_id and sub_id since we are going to use ADO SC
variable "tenant_id" {
  description = "Tenant ID of the Azure account"
  type = string
  default = "65985761-7f3d-42b8-b6d6-661f46cd95eb"
}

variable "subscription_id" {
  description = "Subscription ID of the Azure account where resources will be created"
  type = string
}

variable "location" {
  description = "Location of the Azure resources"
  type = string
  default = "West Europe"
}

variable "environment" {
  description = "Environment for the resources"
  type = string
}

variable "region" {
  description = "Region for the resources"
  type = string
}

variable "web_name" {
  description = "Name of the web resource group"
  type = string
}

variable "app_name" {
  description = "Name of the application resource group"
  type = string
}

variable "tags" {
  description = "Tags to apply to the resources"
  type = map(string)
  default = {}
}