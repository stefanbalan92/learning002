terraform {

  required_version = ">= 1.8.0"

  required_providers {

    azurerm = {

      source = "hashicorp/azurerm"

      version = "~> 4.0" # or whatever you are standardising on

    }

  }

}

provider "azurerm" {

  features {}
  subscription_id = "152f080d-f706-4335-aa03-cf88ca4534e2"
  tenant_id       = "81f5f754-7f3a-4bc2-8b24-8b7c5f468aec"
 
}