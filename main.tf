provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

data "template_file" "cloud_init" {
  template = file("cloud-init.yml")
}

resource "azurerm_virtual_network" "ecom-app" {
  name                = "ECOM04-VNET"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "ecom-app" {
  name                 = "ECOM04-SUBNET"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ecom-app.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "ecom-app" {
  name                = "ECOM04-NSG"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "ecom-app" {
  name                = "NIC-ECOM04"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "NIC-ECOM04-IPConfig"
    subnet_id                     = azurerm_subnet.ecom-app.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_address_id
  }
}

resource "azurerm_network_interface_security_group_association" "ecom-app" {
  network_interface_id      = azurerm_network_interface.ecom-app.id
  network_security_group_id = azurerm_network_security_group.ecom-app.id
}

resource "azurerm_linux_virtual_machine" "ecom-app" {
  name                = "VM-ECOM04"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.public_ssh_key
  }

  network_interface_ids = [azurerm_network_interface.ecom-app.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = base64encode(data.template_file.cloud_init.rendered)

  provision_vm_agent              = true
  allow_extension_operations      = true
}
