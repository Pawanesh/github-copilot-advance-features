output "login_server" {
  description = "The login server hostname for the registry (e.g. myacr.azurecr.io)."
  value       = azurerm_container_registry.this.login_server
}

output "acr_id" {
  description = "The resource id of the container registry."
  value       = azurerm_container_registry.this.id
}
