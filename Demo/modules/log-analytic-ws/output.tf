output "name" {
  description = "The name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.example.name  
}

output "id" {
  description = "The ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.example.id
}

output "primary_shared_key" {
  description = "The Primary shared key for the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.example.primary_shared_key
}

output "secondary_shared_key" {
  description = "The Secondary shared key for the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.example.secondary_shared_key  
}

output "workspace_id" {
  description = "The Workspace (or Customer) ID for the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.example.workspace_id  
}