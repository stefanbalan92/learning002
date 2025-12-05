locals {

  location            = "uksouth"

  resource_group_name = "Test001"
 
  vnet_name      = "vnet001"

  subnet_name    = "subnet001"

  nsg_name       = "nsg001"

  nic_name       = "nic001"

  public_ip_name = "pip001"

  vm_name        = "myVm001"
 
  admin_username = "administrator001"

  # Lab password, do not use in real environments

  admin_password = "ChangeMe123!"

}
 
# Resource group

resource "azurerm_resource_group" "rg" {

  name     = local.resource_group_name

  location = local.location

}
 
# Virtual network

resource "azurerm_virtual_network" "vnet" {

  name                = local.vnet_name

  address_space       = ["10.10.0.0/16"]

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name

}
 
# Subnet

resource "azurerm_subnet" "subnet" {

  name                 = local.subnet_name

  resource_group_name  = azurerm_resource_group.rg.name

  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes     = ["10.10.1.0/24"]

}
 
# Network security group with SSH rule

resource "azurerm_network_security_group" "nsg" {

  name                = local.nsg_name

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name
 
  security_rule {

    name                       = "SSH"

    priority                   = 1000

    direction                  = "Inbound"

    access                     = "Allow"

    protocol                   = "Tcp"

    source_port_range          = "*"

    destination_port_range     = "22"

    source_address_prefix      = "*"

    destination_address_prefix = "*"

  }

}
 
# Public IP

resource "azurerm_public_ip" "pip" {

  name                = local.public_ip_name

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name
 
  allocation_method = "Static"

  sku               = "Standard"

}
 
# Network interface

resource "azurerm_network_interface" "nic" {

  name                = local.nic_name

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name
 
  ip_configuration {

    name                          = "ipconfig1"

    subnet_id                     = azurerm_subnet.subnet.id

    private_ip_address_allocation = "Dynamic"

    public_ip_address_id          = azurerm_public_ip.pip.id

  }

}
 
# Attach NSG to NIC

resource "azurerm_network_interface_security_group_association" "nic_nsg" {

  network_interface_id      = azurerm_network_interface.nic.id

  network_security_group_id = azurerm_network_security_group.nsg.id

}
 
# Linux VM

resource "azurerm_linux_virtual_machine" "vm" {

  name                = local.vm_name

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name
 
  size           = "Standard_B2s"

  admin_username = local.admin_username

  admin_password = local.admin_password
 
  disable_password_authentication = false
 
  network_interface_ids = [

    azurerm_network_interface.nic.id

  ]
 
  os_disk {

    name                 = "osdisk-${local.vm_name}"

    caching              = "ReadWrite"

    storage_account_type = "Standard_LRS"

  }
 
  source_image_reference {

    publisher = "Canonical"

    offer     = "0001-com-ubuntu-server-jammy"

    sku       = "22_04-lts"

    version   = "latest"

  }

}
 
# Output the public IP so you can connect easily

output "vm_public_ip" {

  value       = azurerm_public_ip.pip.ip_address

  description = "Public IP of the demo VM"

}

 