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

}