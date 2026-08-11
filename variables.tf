variable "location" {
  type        = string
  description = "Azure Region (e.g. East US, Central India, West Europe)"
  default     = "East US"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group ka naam"
  default     = "rg-demo-dev"
}

variable "storage_account_name" {
  type        = string
  description = "Storage Account ka naam (Small letters & numbers only, 3-24 characters)"
  default     = "stgdemodev123456"
}

variable "vnet_name" {
  type        = string
  description = "Virtual Network (VNet) ka naam"
  default     = "vnet-demo-dev"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "VNet ka IP address space"
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type        = string
  description = "Subnet ka naam"
  default     = "default-subnet"
}

variable "subnet_address_prefix" {
  type        = list(string)
  description = "Subnet ka IP address range"
  default     = ["10.0.1.0/24"]
}

variable "environment" {
  type        = string
  description = "Environment tag (Dev, Staging, Prod)"
  default     = "Dev"
}
