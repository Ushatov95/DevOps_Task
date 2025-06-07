terraform {
    required_providers {
        azurerm = {
        source = "hashicorp/azurerm"
        version = "~>4.0.0"
        }
    }
}

##TODO: Remove the subscription_id since we are going to use ADO SC
provider "azurerm" {
    subscription_id = var.subscription_id
    features {}
}