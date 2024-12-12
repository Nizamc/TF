output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = element(concat(azurerm_virtual_network.vnet.*.name, [""]), 0)
}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = element(concat(azurerm_virtual_network.vnet.*.id, [""]), 0)
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = element(coalescelist(azurerm_virtual_network.vnet.*.address_space, [""]), 0)
}

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = flatten(concat([for s in azurerm_subnet.snet : s.id], [var.gateway_subnet_address_prefix != null ? azurerm_subnet.gw_snet.0.id : null], [var.firewall_subnet_address_prefix != null ? azurerm_subnet.fw-snet.0.id : null]))
}

output "subnet_address_prefixes" {
  description = "List of address prefix for subnets"
  value       = flatten(concat([for s in azurerm_subnet.snet : s.address_prefixes], [var.gateway_subnet_address_prefix != null ? azurerm_subnet.gw_snet.0.address_prefixes : null], [var.firewall_subnet_address_prefix != null ? azurerm_subnet.fw-snet.0.address_prefixes : null]))
}

output "network_security_group_ids" {
  description = "List of Network security groups and ids"
  value       = [for n in azurerm_network_security_group.nsg : n.id]
}

output "ddos_protection_plan" {
  description = "Ddos protection plan details"
  value       = var.create_ddos_plan ? element(concat(azurerm_network_ddos_protection_plan.ddos.*.id, [""]), 0) : null
}

output "network_watcher_id" {
  description = "ID of Network Watcher"
  value       = var.create_network_watcher != false ? element(concat(azurerm_network_watcher.nwatcher.*.id, [""]), 0) : null
}

output "gateway_subnet_id" {
  description = "The ID of the Gateway Subnet"
  value       = azurerm_subnet.gw_snet[0].id
}

/*
output "pvt_subnet_id" {
  description = "The ID of the private endpoint  Subnet"
  value       = azurerm_subnet.snet[4].id
}
module.vnet.azurerm_subnet.snet["app_subnet"] 
output "web_subnet_id" {
  description = "The ID of the Web Subnet"
  value       = azurerm_subnet.snet[3].id
}

output "db_subnet_id" {
  description = "The ID of the DB Subnet"
  value       = azurerm_subnet.snet[2].id
}

output "app_subnet_id" {
  description = "The ID of the App Subnet"
  value       = azurerm_subnet.snet[1].id
}

output "mgnt_subnet_id" {
  description = "The ID of the management Subnet"
  value       = azurerm_subnet.snet[0].id
}
*/