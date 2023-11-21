terraform {
  required_providers {
    azurerm = {
      version = ">= 3.43"
    }
    random = {
      version = ">= 3.4"
    }
    http = {
      version = ">= 3.2"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-xxx"
    storage_account_name = "stxxx"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}

data "azurerm_client_config" "current" {}

locals {
  # Set the application name
  app = "cks"

  # Lookup and set the location abbreviation, defaults to na (not available).
  location_abbreviation = try(var.location_abbreviation[var.location], "na")

  # Construct the name suffix.
  suffix = "${local.app}-${var.environment}-${local.location_abbreviation}"
}

# Create the resource group.
resource "azurerm_resource_group" "default" {
  name     = "rg-${local.suffix}"
  location = var.location
}
