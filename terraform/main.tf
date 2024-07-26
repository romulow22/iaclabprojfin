################# LANDING ZONE ######################

# Gerar grupo de recursos 
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "${var.project}-rg"
}

# Criar Rede Virtual 
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.project}-vnet"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [azurerm_resource_group.rg]
}

# Criar SubNet para Servidores Backend 
resource "azurerm_subnet" "my_backend_subnet" {
  name                 = "${var.project}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = var.subbackend_address_space

  depends_on = [azurerm_virtual_network.myvnet, azurerm_resource_group.rg]
}

# Criar grupo de seguranca de rede e regra 
resource "azurerm_network_security_group" "my_nsg" {
  name                = "${var.project}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "myNSGRuleHTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["80"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "myNSGRuleSSH"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [azurerm_resource_group.rg]
}

################ VIRTUAL MACHINE #############################

# Create public IP
resource "azurerm_public_ip" "my_public_ip" {
  name                = "${var.project}-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "my_nic" {
  name                = "${var.project}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.project}-nic-configuration"
    subnet_id                     = azurerm_subnet.my_backend_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_public_ip.id
  }
  depends_on = [azurerm_public_ip.my_public_ip]
}

# Conecta NSG com VM
resource "azurerm_network_interface_security_group_association" "net_nsg_vm" {
  network_interface_id      = azurerm_network_interface.my_nic.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id

  depends_on = [azurerm_network_interface.my_nic]
}

# Gera texto randomico para storage
resource "random_id" "random_vm_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }
  byte_length = 8
}

# Cria conta storage VM pra diagnosticar boot
resource "azurerm_storage_account" "my_vm_storage_account" {
  name                     = "diagboot${random_id.random_vm_id.hex}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [random_id.random_vm_id]
}

# Cria VM
resource "azurerm_linux_virtual_machine" "my_vm" {
  name                = "${var.project}-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [
    azurerm_network_interface.my_nic.id
  ]
  size = var.vm_sku

  os_disk {
    name                 = "${var.project}-vm_OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "${var.project}-vm"
  admin_username                  = var.vm_admin_username
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_vm_storage_account.primary_blob_endpoint
  }

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [
    azurerm_network_interface_security_group_association.net_nsg_vm,
    azurerm_storage_account.my_vm_storage_account
  ]
}


################ ANSIBLE INVENTORY FILE #############################
resource "local_file" "ansible_inventory" {
  content = templatefile("../ansible/inventory.tpl", {
    vm_ip       = azurerm_public_ip.my_public_ip.ip_address
    vm_user     = var.vm_admin_username
    vm_password = var.vm_admin_password
  })
  filename   = "../ansible/inventory.ini"
  depends_on = [azurerm_linux_virtual_machine.my_vm]
}