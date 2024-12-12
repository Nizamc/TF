output "name" {
  value = azurerm_resource_group.rg[0].name
  
}
output "location" {
  value = azurerm_resource_group.rg[0].location
}