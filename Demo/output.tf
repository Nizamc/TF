################################ Resource Group ####################
output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = module.resource_group_name.name
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = module.resource_group_name.location
}

################################# VNet and Subnets #############################
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = module.vnet.virtual_network_name
}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = module.vnet.virtual_network_id
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = module.vnet.virtual_network_address_space
}

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = module.vnet.subnet_ids
}

output "subnet_address_prefixes" {
  description = "List of address prefix for subnets"
  value       = module.vnet.subnet_address_prefixes
}

output "network_security_group_ids" {
  description = "List of Network security groups and ids"
  value       = module.vnet.network_security_group_ids
}

# DDoS Protection plan
output "ddos_protection_plan" {
  description = "Ddos protection plan details"
  value       = module.vnet.ddos_protection_plan
}

# Network Watcher
output "network_watcher_id" {
  description = "ID of Network Watcher"
  value       = module.vnet.network_watcher_id
}

output "gateway_subnet_id" {
  description = "The ID of the Gateway Subnet"
  value       = module.vnet.gateway_subnet_id
}

################## application insights ############################

output "application_insights_id" {
  description = "The ID of the Application Insights component"
  value       = module.application-insights.application_insights_id
}

output "app_insights_app_id" {
  description = "The App ID associated with this Application Insights component"
  value       = module.application-insights.app_insights_app_id
}

output "app_insights_instrumentation_key" {
  description = "he Instrumentation Key for this Application Insights component"
  value       = module.application-insights.app_insights_instrumentation_key
  sensitive   = true
}

output "app_insights_connection_string" {
  description = "The Connection String for this Application Insights component"
  value       = module.application-insights.app_insights_connection_string
  sensitive   = true
}
########################## Log analytics workspace ############################
output "id" {
  value       = module.log_analytics_workspace.id
  description = "The Log Analytics Workspace ID."
}

output "name" {
  value       = module.log_analytics_workspace.name
  description = "The Log Analytics Workspace name."
}

output "primary_shared_key" {
  value       = module.log_analytics_workspace.primary_shared_key
  description = "The Primary shared key for the Log Analytics Workspace."
  sensitive   = true
}

output "secondary_shared_key" {
  value       = module.log_analytics_workspace.secondary_shared_key
  description = "The Secondary shared key for the Log Analytics Workspace."
  sensitive   = true
}

output "workspace_id" {
  value       = module.log_analytics_workspace.workspace_id
  description = "The Workspace (or Customer) ID for the Log Analytics Workspace."
}

########################## storage account ############################
output "storage_account_id" {
  description = "The ID of the storage account."
  value       = module.storage.storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = module.storage.storage_account_name
}

output "storage_account_primary_location" {
  description = "The primary location of the storage account"
  value       = module.storage.storage_account_primary_location
}

output "storage_account_primary_web_endpoint" {
  description = "The endpoint URL for web storage in the primary location."
  value       = module.storage.storage_account_primary_web_endpoint
}

output "storage_account_primary_web_host" {
  description = "The hostname with port if applicable for web storage in the primary location."
  value       = module.storage.storage_account_primary_web_host
}

output "storage_primary_connection_string" {
  description = "The primary connection string for the storage account."
  value       = module.storage.storage_primary_connection_string
  sensitive   = true
}

output "storage_primary_access_key" {
  description = "The primary access key for the storage account."
  value       = module.storage.storage_primary_access_key
  sensitive   = true
}

output "storage_secondary_access_key" {
  description = "The secondary access key for the storage account."
  value       = module.storage.storage_secondary_access_key
  sensitive   = true
}

output "containers" {
  description = "Map of containers."
  value       = module.storage.containers
}



###################################### Key vault #########################
output "key_vault_id" {
  description = "The ID of the Key Vault."
  value       = module.key-vault.key_vault_id
}

output "key_vault_name" {
  description = "Name of key vault created."
  value       = module.key-vault.key_vault_name
}

output "key_vault_uri" {
  description = "The URI of the Key Vault, used for performing operations on keys and secrets."
  value       = module.key-vault.key_vault_uri
}

output "secrets" {
  description = "A mapping of secret names and URIs."
  value       = module.key-vault.secrets
}

output "Key_vault_references" {
  description = "A mapping of Key Vault references for App Service and Azure Functions."
  value       = module.key-vault.Key_vault_references
}

output "key_vault_private_endpoint" {
  description = "The ID of the Key Vault Private Endpoint"
  value       = module.key-vault.key_vault_private_endpoint
}

output "key_vault_private_dns_zone_domain" {
  description = "DNS zone name for Key Vault Private endpoints dns name records"
  value       = module.key-vault.key_vault_private_dns_zone_domain
}

output "key_vault_private_endpoint_ip_addresses" {
  description = "Key Vault private endpoint IPv4 Addresses"
  value       = module.key-vault.key_vault_private_endpoint_ip_addresses
}

output "key_vault_private_endpoint_fqdn" {
  description = "Key Vault private endpoint FQDN Addresses"
  value       = module.key-vault.key_vault_private_endpoint_fqdn
}


/*
output "pvt_subnet_id" {
  description = "The ID of the privateendpoint  Subnet"
  value       = module.vnet.pvt_subnet_id
}

output "web_subnet_id" {
  description = "The ID of the Web Subnet"
  value       = module.vnet.web_subnet_id
}

output "db_subnet_id" {
  description = "The ID of the DB Subnet"
  value       = module.vnet.db_subnet_id
}

output "app_subnet_id" {
  description = "The ID of the App Subnet"
  value       = module.vnet.app_subnet_id
}

output "mgnt_subnet_id" {
  description = "The ID of the management Subnet"
  value       = module.vnet.mgnt_subnet_id
}
#************************GW*****************************
/*
output "vpn_gateway_id" {
  description = "The resource ID of the virtual network gateway"
  value       = module.vpn-gateway.vpn_gateway_id
}

output "vpn_gateway_public_ip" {
  description = "The public IP of the virtual network gateway"
  value       = module.vpn-gateway.vpn_gateway_public_ip
}

output "vpn_gateway_public_ip_fqdn" {
  description = "Fully qualified domain name of the virtual network gateway"
  value       = module.vpn-gateway.vpn_gateway_public_ip_fqdn
}
#####################SQL################################
output "storage_account_id" {
  description = "The ID of the storage account"
  value       = module.mssql-server.storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = module.mssql-server.storage_account_name
}

output "primary_sql_server_id" {
  description = "The primary Microsoft SQL Server ID"
  value       = module.mssql-server.primary_sql_server_id
}

output "primary_sql_server_fqdn" {
  description = "The fully qualified domain name of the primary Azure SQL Server"
  value       = module.mssql-server.primary_sql_server_fqdn
}

output "sql_server_admin_user" {
  description = "SQL database administrator login id"
  value       = module.mssql-server.sql_server_admin_user
  sensitive   = true
}

output "sql_server_admin_password" {
  description = "SQL database administrator login password"
  value       = module.mssql-server.sql_server_admin_password
  sensitive   = true
}

output "sql_database_id" {
  description = "The SQL Database ID"
  value       = module.mssql-server.sql_database_id
}

output "sql_database_name" {
  description = "The SQL Database Name"
  value       = module.mssql-server.sql_database_name
}

output "primary_sql_server_private_endpoint" {
  description = "id of the Primary SQL server Private Endpoint"
  value       = module.mssql-server.primary_sql_server_private_endpoint
}

output "sql_server_private_dns_zone_domain" {
  description = "DNS zone name of SQL server Private endpoints dns name records"
  value       = module.mssql-server.sql_server_private_dns_zone_domain
}

output "primary_sql_server_private_endpoint_ip" {
  description = "Priamary SQL server private endpoint IPv4 Addresses "
  value       = module.mssql-server.primary_sql_server_private_endpoint_ip
}

output "primary_sql_server_private_endpoint_fqdn" {
  description = "Priamary SQL server private endpoint IPv4 Addresses "
  value       = module.mssql-server.primary_sql_server_private_endpoint_fqdn
}

*/