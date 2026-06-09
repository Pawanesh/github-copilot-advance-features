terraform {
  required_version = ">= 1.4.0"
}

provider "azurerm" {
  features = {}
}

# NOTE: This is a scaffold. Fill values and add required blocks.

resource "azurerm_resource_group" "rg" {
  name     = "rg-shopping-dev"
  location = var.location
}

# Log Analytics workspace for Container Apps
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-shopping-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

# Container Apps environment
resource "azurerm_container_app_environment" "cae" {
  name                = "cae-shopping-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  log_analytics {
    customer_id = azurerm_log_analytics_workspace.law.workspace_id
    shared_key  = azurerm_log_analytics_workspace.law.primary_shared_key
  }
}

# User-assigned Managed Identity for Container Apps
resource "azurerm_user_assigned_identity" "ca_identity" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "uai-shopping-${var.environment}"
}

# Cosmos DB account (SQL API)
resource "azurerm_cosmosdb_account" "cosmos" {
  name                = "cosmos-shopping-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "db" {
  name                = "ShoppingDb"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos.name
}

resource "azurerm_cosmosdb_sql_container" "products" {
  name                = "products"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  database_name       = azurerm_cosmosdb_sql_database.db.name
  partition_key_path  = "/categoryId"
  throughput          = 400
}

resource "azurerm_cosmosdb_sql_container" "users" {
  name                = "users"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  database_name       = azurerm_cosmosdb_sql_database.db.name
  partition_key_path  = "/id"
  throughput          = 400
}

resource "azurerm_cosmosdb_sql_container" "carts" {
  name                = "carts"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  database_name       = azurerm_cosmosdb_sql_database.db.name
  partition_key_path  = "/userId"
  throughput          = 400
}

resource "azurerm_cosmosdb_sql_container" "orders" {
  name                = "orders"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  database_name       = azurerm_cosmosdb_sql_database.db.name
  partition_key_path  = "/userId"
  throughput          = 400
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

# Container App - Backend
resource "azurerm_container_app" "backend" {
  name                = "ca-backend-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.cae.id

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.ca_identity.id]
  }

  configuration {
    ingress {
      external_enabled = true
      target_port      = 8000
      transport         = "Auto"
    }

    registries {
      server          = "ghcr.io"
      username        = var.ghcr_username
      password_secret = "GHCR_TOKEN"
    }
  }

  secret {
    name  = "GHCR_TOKEN"
    value = var.ghcr_pat
  }

  container {
    name   = "backend"
    image  = var.backend_image
    cpu    = 0.5
    memory = "1Gi"
    env {
      name  = "COSMOS_ENDPOINT"
      value = azurerm_cosmosdb_account.cosmos.endpoint
    }
    env {
      name  = "COSMOS_KEY"
      secret = azurerm_cosmosdb_account.cosmos.primary_master_key
    }
  }
}

# Container App - Frontend (serves static site)
resource "azurerm_container_app" "frontend" {
  name                = "ca-frontend-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.cae.id

  configuration {
    ingress {
      external_enabled = true
      target_port      = 80
      transport         = "Auto"
    }

    registries {
      server          = "ghcr.io"
      username        = var.ghcr_username
      password_secret = "GHCR_TOKEN"
    }
  }

  secret {
    name  = "GHCR_TOKEN"
    value = var.ghcr_pat
  }

  container {
    name   = "frontend"
    image  = var.frontend_image
    cpu    = 0.25
    memory = "0.5Gi"
    env {
      name  = "VITE_API_URL"
      value = "https://${azurerm_container_app.backend.configuration[0].ingress[0].fqdn}/api"
    }
  }
}
