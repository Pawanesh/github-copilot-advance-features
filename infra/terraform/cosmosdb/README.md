# CosmosDB Terraform module

Creates a Cosmos DB account (SQL API), a SQL database, and three containers: `users`, `inventory`, and `carts`.

Example usage from the root module:

```hcl
module "cosmosdb" {
  source              = "./cosmosdb"
  name                = "cosmos-shopping-${var.environment}"
  resource_group_name = module.resource_group.name
  location            = var.location
  database_name       = "ShoppingDb"
  throughput          = 400
}

output "cosmos_endpoint" { value = module.cosmosdb.cosmos_endpoint }
```
