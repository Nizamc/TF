terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # version = ">= 4.11.0"
      version = ">= 3.28.0"
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
  subscription_id = "43f1447a-7f1d-4da2-ab95-65d728c49eb9"
}

