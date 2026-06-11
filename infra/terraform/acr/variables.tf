variable "name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the ACR."
  type        = string
}

variable "location" {
  description = "Azure region for the ACR."
  type        = string
  default     = "centralus"
}

variable "sku" {
  description = "ACR SKU. Options: Basic, Standard, Premium."
  type        = string
  default     = "Basic"
}

variable "admin_enabled" {
  description = "Whether to enable the admin user for the registry (not recommended for production)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to set on the registry."
  type        = map(string)
  default     = {}
}
