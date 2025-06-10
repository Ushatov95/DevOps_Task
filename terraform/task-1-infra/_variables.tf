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