terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
    random  = { source = "hashicorp/random" }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

locals {
  tags = { owner = "paula", purpose = "lab", cost_center = "personal" }
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "lab" {
  name     = "rg-dbx-lab"
  location = "centralus"
  tags     = local.tags
}

resource "azurerm_storage_account" "lab" {
  name                     = "stdbxlab${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.lab.name
  location                 = azurerm_resource_group.lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
}
