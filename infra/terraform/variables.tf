variable "location" {
  type    = string
  default = "eastus"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "ghcr_username" {
  type = string
  description = "GHCR username (github actor or org)"
}

variable "ghcr_pat" {
  type = string
  description = "Personal access token for GHCR (used as secret). Provide via terraform.tfvars or pipeline."
  sensitive = true
}

variable "backend_image" {
  type = string
  description = "Full image reference for backend (e.g. ghcr.io/<owner>/online-shopping-backend:tag)"
}

variable "frontend_image" {
  type = string
  description = "Full image reference for frontend (e.g. ghcr.io/<owner>/online-shopping-frontend:tag)"
}

variable "acr_name" {
  type        = string
  description = "Azure Container Registry name (must be globally unique, lowercase)"
  default     = "shoppingacrdev"
}
