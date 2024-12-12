#------------------------
# Local declarations
#------------------------
locals {
  resource_group_name = var.resource_group_name
  location = var.location
}

#------------------------
# Log Analytics Workspace
#------------------------

resource "azurerm_log_analytics_workspace" "example" {
  #count                              = var.create_resource_group || length(data.azurerm_log_analytics_workspace.existing) == 0 ? 1 : 0
  name                               = var.workspace_name
  location                           = local.location
  resource_group_name                = var.resource_group_name
  tags                               = merge({ "Name" = format("%s", var.resource_group_name) }, var.tags)
  sku                                = var.sku
  retention_in_days                  = var.retention_in_days
  daily_quota_gb                     = var.daily_quota_gb
  internet_ingestion_enabled         = var.internet_ingestion_enabled
  internet_query_enabled             = var.internet_query_enabled
  #reservation_capacity_in_gb_per_day = var.reservation_capcity_in_gb_per_day
}