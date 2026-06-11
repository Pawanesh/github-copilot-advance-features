variable "name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
  default     = "centralus"
}

variable "tags" {
  description = "Tags to set on the resource group"
  type        = map(string)
  default     = {}
}
