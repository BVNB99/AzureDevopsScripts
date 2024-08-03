terraform {
  backend "azurerm" {
    resource_group_name     = "test-rg"
    storage_account_name    = "tfbackendstorage1"
    container_name          = "terraform-state-test"
    key                     = "terraform.tfstate"
  }

}
provider "azurerm" {
features {}
}

module "azure_vm" {
  source                = "../azure_vm_module"
  resource_group_name   = "test-rg-1"
  location              = "East US"
  vnet_name             = "testVnet1"
  vnet_address_space    = "10.0.0.0/16"
  subnet_name           = "testSubnet1"
  subnet_prefix         = "10.0.1.0/24"
  nic_name              = "testNic1"
  no_of_vms             = 1
  vm_size               = "Standard_DS1_v2"
  disk_type             = "Standard_LRS"
  disk_name             = "vmDisk1"
  admin_username        = "test_user"
  admin_password        = "Test_Password@12"
}

