variable "app_name" {
  description = "Name of the Azure Web App"
  type        = string
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group where resources will be deployed"
  type        = string
}

variable "location" {
  description = "Azure location for all resources"
  type        = string
}

variable "environment" {
  description = "The environment name (dev, acc, prd)"
  type        = string
}

variable "region" {
  description = "Region for the resources"
  type = string
  default = "weu"
}

variable "os_type" {
  description = "Specifies the kind of the App Service Plan"
  type        = string
}

variable "sku_name" {
  description = "The pricing tier for the App Service Plan"
  type        = string
}

variable "python_version" {
  description = "Python version for the Web App"
  type        = string
}

variable "app_settings" {
  description = "App settings to configure on the Web App"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(any)
  default     = null
}
