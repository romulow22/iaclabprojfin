output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "The name of the resource group"
}

output "virtual_network_id" {
  value       = azurerm_virtual_network.myvnet.id
  description = "The ID of the virtual network"
}

output "virtual_network_name" {
  value       = azurerm_virtual_network.myvnet.name
  description = "The name of the virtual network"
}

output "backend_subnet_id" {
  value       = azurerm_subnet.my_backend_subnet.id
  description = "The ID of the backend subnet"
}

output "backend_subnet_address_prefix" {
  value       = azurerm_subnet.my_backend_subnet.address_prefixes
  description = "The address prefix of the backend subnet"
}

output "network_security_group_id" {
  value       = azurerm_network_security_group.my_nsg.id
  description = "The ID of the network security group"
}


output "network_security_group_name" {
  value       = azurerm_network_security_group.my_nsg.name
  description = "The name of the network security group"
}

output "private_ip_addresses" {
  value       = azurerm_linux_virtual_machine.my_vm.private_ip_addresses
  description = "The private IP addresses of the virtual machine"
}

output "public_ip_addresses" {
  value       = azurerm_linux_virtual_machine.my_vm.public_ip_addresses
  description = "The public IP addresses of the virtual machine"
}

output "network_interface_id" {
  value = azurerm_network_interface.my_nic.id
}

output "network_interface_name" {
  value = azurerm_network_interface.my_nic.name
}

output "storage_account_name" {
  value = azurerm_storage_account.my_vm_storage_account.name
}

output "storage_account_primary_blob_endpoint" {
  value = azurerm_storage_account.my_vm_storage_account.primary_blob_endpoint
}

output "virtual_machine_id" {
  value = azurerm_linux_virtual_machine.my_vm.id
}

output "virtual_machine_name" {
  value = azurerm_linux_virtual_machine.my_vm.name
}

output "private_ip_address" {
  value = azurerm_linux_virtual_machine.my_vm.private_ip_address
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.my_vm.public_ip_address
}