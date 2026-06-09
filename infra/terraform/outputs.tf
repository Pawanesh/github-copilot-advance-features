output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "cosmos_endpoint" {
  value = azurerm_cosmosdb_account.cosmos.endpoint
}

output "backend_fqdn" {
  value = azurerm_container_app.backend.configuration[0].ingress[0].fqdn
}

output "frontend_fqdn" {
  value = azurerm_container_app.frontend.configuration[0].ingress[0].fqdn
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}
