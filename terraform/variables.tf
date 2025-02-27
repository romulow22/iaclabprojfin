variable "vm_admin_username" {
  description = "The admin username for the virtual machine."
  type        = string
  default     = "acmedmin"
}


variable "vm_admin_password" {
  description = "The admin password for the virtual machine."
  type        = string
  default     = "Teste12345"
}

variable "project" {
  description = "The name of the project."
  type        = string
  default     = "piloto"
}

variable "location" {
  type        = string
  default     = "brazilsouth"
  description = "Location of the resources"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subbackend_address_space" {
  description = "The address space for the backend subnet."
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "vm_sku" {
  description = "SKU for the VM."
  type        = string
}
