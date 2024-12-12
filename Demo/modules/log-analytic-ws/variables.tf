variable "create_resource_group" {
  description = "Create a new resource group"
  type        = bool
  default     = false  
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string  
}

variable "sku" {
  description = "The SKU (pricing tier) of the Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"  
}

variable "location" {
  description = "Location of the resource group"
  type        = string
}

variable "workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
}

variable "retention_in_days" {
  description = "Retention in days for the Log Analytics Workspace. Possible values are between 30 and 730. Default is 30"
  type        = number
  default     = 30
}

variable "daily_quota_gb" {
  description = "Daily quota in GB for the Log Analytics Workspace. To remove limit, set to -1. default is 0.5"
  type        = number
  default     = 0.5
}

variable "internet_ingestion_enabled" {
  description = "Should the Log Analytics Workflow support ingestion over the Public Internet ?"
  type        = bool
  default     = false
}

variable "internet_query_enabled" {
  type        = bool
  default     = true
  description = "Should the Log Analytics Workflow support querying over the Public Internet ?"
}

variable "reservation_capcity_in_gb_per_day" {
  description = "The capacity reservation level in GB for this workspace. Must be in increments of 100 between 100 and 5000."
  type        = number
  default     = 100
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "create_log_analytics_workspace" {
  description = "Create a new Log Analytics Workspace"
  type        = bool
  default     = true  
}