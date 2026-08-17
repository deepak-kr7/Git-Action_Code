terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  # Azure Remote Backend Configuration for Terraform State (.tfstate)
  backend "azurerm" {
    resource_group_name  = "test_RG"
    storage_account_name = "teststodeep111"
    container_name       = "testcontainer111"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "random" {}
