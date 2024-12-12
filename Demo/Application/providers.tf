terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.28.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.16"
    }
  }
  required_version = ">= 1.1.9"
}

provider "azurerm" {
  alias = "log_analytics_custom_config"
  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = !var.law_soft_delete_enabled
    }
  }

}

provider "azurerm" {
  features {}
  subscription_id = "e6b43cb4-eaf9-4ef0-a0fa-aae925dae9f6"
}

