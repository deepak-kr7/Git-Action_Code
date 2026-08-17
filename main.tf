# ==============================================================================
# 0. Random String Generator (3 Character Suffix for Storage Account)
# ==============================================================================
resource "random_string" "random" {
  length  = 3
  special = false
  upper   = false
}

# ==============================================================================
# 1. Resource Group Creation
# ==============================================================================
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ==============================================================================
# 2. Storage Account Creation
# ==============================================================================
resource "azurerm_storage_account" "storage" {
  name                     = "${var.storage_account_name}${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  depends_on = [
    azurerm_resource_group.rg,
    random_string.random
  ]
}

# ==============================================================================
# 3. Virtual Network (VNet) Creation
# ==============================================================================
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Subnet inside Virtual Network
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix

  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_resource_group.rg
  ]
}
