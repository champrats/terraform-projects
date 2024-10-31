# Setup the provider 
# On the link, click "User Provider" to get the latest provider syntax and version - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs 

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.7.0"
    }
  }
}

# Starting from version 4.0, specifying the subscription ID in the provider section is mandatory. Refer to this link: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide#specifying-subscription-id-is-now-mandatory 
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Create a storage account. Refer to: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account

resource "azurerm_resource_group" "terraform-rg" {
  name     = "terraform-rg"
  location = "australiacentral"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "labaigoadlsauc1"
  resource_group_name      = azurerm_resource_group.terraform-rg.name
  location                 = azurerm_resource_group.terraform-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "lab"
  }
}