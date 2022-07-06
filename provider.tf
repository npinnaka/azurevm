
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.12.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
  }
  skip_provider_registration = true
  subscription_id            = "0f39574d-d756-48cf-b622-0e27a6943bd2"
}

