# Azure Container Registry (ACR) Terraform module

Creates an Azure Container Registry.

Usage example (root module):

```hcl
module "acr" {
  source              = "./acr"
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
  tags = {
    project = "shopping"
    env     = var.environment
  }
}

output "acr_login_server" {
  value = module.acr.login_server
}
```

Notes:
- For CI, prefer GitHub OIDC or a service principal instead of enabling the ACR admin user.
- To get admin credentials when `admin_enabled = true`, use the Azure CLI:

```bash
az acr credential show --name <acr-name> --resource-group <rg>
```
