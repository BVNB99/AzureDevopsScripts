resource "azurerm_resource_group" "main" {
  name			= var.resource_group_name
  location		= var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name				=	var.aks_cluster_name
  location			= 	var.location
  resource_group_name 	= var.resource_group_name
  dns_prefix			= var.dns_prefix
  
  default_node_pool {
    name			= "default"
	node_count		= var.default_node_count
	vm_size			= var.vm_size
	os_disk_size_gb	= var.os_disk_size
  }
  
  identity	{
    type	= "SystemAssigned"
  }
  
  linux_profile {
    admin_username	= var.admin_username
	ssh_key	{
	  key_data = var.ssh_public_key
	}
  }
  
  network_profile {
    network_plugin		= "azure"
	network_policy		= "calico"
  }
  
  role_based_access_control_enabled		= true
  tags		= var.tags
}
