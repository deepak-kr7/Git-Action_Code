terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Azure Remote Backend Configuration for Terraform State (.tfstate)
  # Pipeline chalane se pehle Azure me ye Resource Group, Storage Account aur Container bane hone chahiye.
  backend "azurerm" {
    resource_group_name  = "cicd_test"
    storage_account_name = "storagecicd12" # Global unique storage account name for state
    container_name       = "cicdcontainer"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
