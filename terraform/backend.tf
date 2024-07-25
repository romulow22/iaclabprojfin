# backend
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstatestudent"
    storage_account_name = "stgtfstatestudent"
    container_name       = "tfstatecontainer"
    key                  = "terraform.tfstate"
  }
}
