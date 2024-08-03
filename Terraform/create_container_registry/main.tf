provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "create_rg" {
    name        =       "test-rg"
    location    =       "East US"
}

resource "azurerm_container_registry" "create_container" {
    name        =       "democicdar"
    resource_group_name =       azurerm_resource_group.create_rg.name
    location            =       azurerm_resource_group.create_rg.location
    sku                 =       "Basic"
    admin_enabled       =       false
}

