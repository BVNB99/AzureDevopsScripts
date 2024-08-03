provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "create_rg" {
    name       =       "test-rg"
    location   =       "East US"
}

resource "azurerm_storage_account" "create_storage" {
    name        =       "tfbackendstorage1"
    resource_group_name         =       azurerm_resource_group.create_rg.name
    location                    =       azurerm_resource_group.create_rg.location
    account_tier                =       "Standard"
    account_replication_type    =       "LRS"
    tags = {
        environment     =       "terraform-backend"
    }
}

resource "azurerm_storage_container" "create_container" {
    name                        =       "terraform-state-test"
    storage_account_name        =       azurerm_storage_account.create_storage.name
    container_access_type       =       "private"
}


