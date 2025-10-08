terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}

  client_id       = jsondecode(var.azure_credentials)["clientId"]
  client_secret   = jsondecode(var.azure_credentials)["clientSecret"]
  subscription_id = jsondecode(var.azure_credentials)["subscriptionId"]
  tenant_id       = jsondecode(var.azure_credentials)["tenantId"]
}

variable "azure_credentials" {
  type = string
}

resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

resource "azurerm_resource_group" "example" {
  name     = "rg-test-${random_integer.suffix.result}"
  location = "East US"
}