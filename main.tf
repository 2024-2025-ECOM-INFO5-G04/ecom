provider "azurerm" {
  features {}
  subscription_id = "27152942-a39b-441f-905e-cc6165c153de"
}

data "template_file" "cloud_init" {
  template = file("cloud-init.yml")
}

resource "azurerm_resource_group" "example" {
  name     = "MMMG04"
  location = "West Europe"
}

resource "azurerm_public_ip" "example" {
  name                = "myStaticIP"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

resource "azurerm_virtual_network" "example" {
  name                = "ECOM04-VNET"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "ECOM04-SUBNET"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "example" {
  name                = "ECOM04-NSG"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

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

resource "azurerm_network_interface" "example" {
  name                = "NIC-ECOM04"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "NIC-ECOM04-IPConfig"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "VM-ECOM04"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDmblgonLIm7elzzmKX6cjV8c8TTJM2H/cKxr5RmxrPr69oi7KqP8Vp87aIFF+VupcCNpE7CBchrphZ5JcCugRnEFT1VliKMx0u84a4xl0I+GHAVdrbDU+vkq2cCh51b3rlhV9GD+youmX6CXJkIagXxPpxbC0jfInWAEx8dbhySuTokQ+VUkrNjrFjFmzSVPHZOip/DN/qBP7ddyFapAOiCzI3clwD0738OdqTq3S3XEIiLz/KEx2NDRpl2Rl6OYwuISaqr4qlDY51LqBhEI7sm92JX7gxVoRD1SQtlT46CB5fJ4q5KYo4jR4txxW6Z5abVBJLcZY10Ijhf6IjSacVDNx2DplGNXT8R9VsrvDb9c5HSeDAYLzSzzblxsyZITUQqrAlikmIaThBxaCwmsfpg1vaUdQbLkqgPk/bHB+Mt1IWFdD5KPATv958X1ku0Vo0xvd+PEBD7kkxLFo87soPTCnzJqu6H/ablhumUdIZrw5gI2XOrUi8VbRxjDSBFE= generated-by-azure"
  }

  network_interface_ids = [azurerm_network_interface.example.id]

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
