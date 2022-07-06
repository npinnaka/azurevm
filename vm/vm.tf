data "azurerm_resource_group" "rg" {
  name = "1-2c66f3d0-playground-sandbox"
}

data "azurerm_virtual_network" "vnet" {
  name                = "1-2c66f3d0-playground-sandbox-vnet"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

resource "azurerm_network_interface" "nic" {
  name                = "${local.resource_name}-nic"
  location            = data.azurerm_virtual_network.vnet.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  admin_username                  = "someuser"
  admin_password                  = "welco#234me"
  location                        = data.azurerm_virtual_network.vnet.location
  name                            = "${local.resource_name}-vm"
  network_interface_ids           = [azurerm_network_interface.nic.id]
  resource_group_name             = data.azurerm_resource_group.rg.name
  disable_password_authentication = false

  size = "Standard_F2"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

locals {
  resource_name = "prasad-${var.suffix}"
}