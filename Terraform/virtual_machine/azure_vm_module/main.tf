resource "azurerm_resource_group" "rg_main" {
  name            = var.resource_group_name
  location      = var.location
}

resource "azurerm_virtual_network" "network_group" {
  name                            = var.vnet_name
  address_space             = [var.vnet_address_space]
  location                      = azurerm_resource_group.rg_main.location
  resource_group_name   = azurerm_resource_group.rg_main.name
}

resource "azurerm_subnet" "subnet_1" {
  name                              = var.subnet_name
  resource_group_name      = azurerm_resource_group.rg_main.name
  virtual_network_name  = azurerm_virtual_network.network_group.name
  address_prefixes          = [var.subnet_prefix]
}

resource "azurerm_public_ip" "public_ip_data" {
  count               = var.no_of_vms
  name                            = "vm-public-ip-${count.index}"
  location                      = azurerm_resource_group.rg_main.location
  resource_group_name   = azurerm_resource_group.rg_main.name
  allocation_method       = "Dynamic"
}

resource "azurerm_network_interface" "network_id" {
  count                 = var.no_of_vms
  name                              = "testNic-${count.index}"
  location                        = azurerm_resource_group.rg_main.location
  resource_group_name     = azurerm_resource_group.rg_main.name

  ip_configuration {
        name                                                = "internal"
          subnet_id                                       = azurerm_subnet.subnet_1.id
          private_ip_address_allocation         = "Dynamic"
          public_ip_address_id                  = element(azurerm_public_ip.public_ip_data.*.id, count.index)
  }
}

resource "azurerm_network_security_group" "security_group_1" {
  name                            = "SSHSecurityGroup1"
  location                      = azurerm_resource_group.rg_main.location
  resource_group_name   = azurerm_resource_group.rg_main.name

  security_rule {
        name                                            = "testSG1"
          priority                                    = 1000
          direction                                   = "Inbound"
          access                                              = "Allow"
          protocol                                    = "Tcp"
          source_port_range                     = "*"
          destination_port_range            = "22"
          source_address_prefix             = "*"
          destination_address_prefix    = "*"
  }
}

#resource "azurerm_network_interface_security_group_association" "connect_security_group" {
#  network_interface_id          = element(azurerm_network_interface.network_id.*.id, count.index)
#  network_security_group_id     = azurerm_network_security_group.security_group_1.id
#}

resource "azurerm_storage_account" az_storage_account {
  name                                      = "bootdata"
  resource_group_name               = azurerm_resource_group.rg_main.name
  location                                  = azurerm_resource_group.rg_main.location
  account_tier                          = "${element(split("_", var.disk_type),0)}"
  account_replication_type      = "${element(split("_", var.disk_type),1)}"
}

resource "azurerm_virtual_machine" "vm_1" {
  count                   = var.no_of_vms
  name                                = "test-vm-${count.index}"
  location                          = azurerm_resource_group.rg_main.location
  resource_group_name     = azurerm_resource_group.rg_main.name
  network_interface_ids   = [element(azurerm_network_interface.network_id.*.id, count.index)]
  vm_size                             = var.vm_size

  storage_os_disk {
          name                          = "vmDisk${count.index}"
          caching                             = "ReadWrite"
          managed_disk_type     = var.disk_type
          disk_size_gb            = 30
          create_option                 = "FromImage"
  }

  storage_image_reference {
        publisher       = "Canonical"
            offer                 = "UbuntuServer"
            sku               = "18.04-LTS"
            version       = "latest"
  }

  os_profile {
        computer_name           = "test-vm-${count.index}"
        admin_username          = var.admin_username
        admin_password          = var.admin_password
  }

  boot_diagnostics {
        enabled           = "true"
          storage_uri   = "${azurerm_storage_account.az_storage_account.primary_blob_endpoint}"
  }

  os_profile_linux_config {
    disable_password_authentication = false

          #ssh_keys {
        #  path                   = var.path
          #  key_data   = var.key_data
        #}
}


  #provisioner "remote-exec" {
  #  connection {
  #    type     = "ssh"
  #    user     = var.admin_username
  #    password = var.admin_password
  #    host     = "13.92.255.226"
  #  }
  #  inline = [
  #        "sudo apt-add-repository ppa:ansible/ansible",
  #       "sudo apt update",
  #       "sudo apt install -y ansible",
  #     ]
  #}
}

