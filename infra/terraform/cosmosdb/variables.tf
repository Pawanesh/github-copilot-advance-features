variable "name" {
  description = "Name of the Cosmos DB account"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to create the account in"
  type        = string
}

variable "location" {
  description = "Azure location for Cosmos DB"
  type        = string
  default     = "centralus"
}

variable "database_name" {
  description = "Name of the SQL database"
  type        = string
  default     = "ShoppingDb"
}

variable "throughput" {
  description = "Throughput RU/s for each container"
  type        = number
  default     = 400
}

variable "environment" {
  description = "Deployment environment (dev/stage/prod)"
  type        = string
  default     = "dev"
}
