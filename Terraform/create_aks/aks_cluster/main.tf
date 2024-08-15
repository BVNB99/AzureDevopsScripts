provider "azurerm" {
  features {}
}

module "azure_aks" {
  source 	= "../aks_module"
  tags 		= {
    environment	= "dev"
	project		= "terraform-aks"
  }
  resource_group_name	= "cluster-rg"
  location				= "East US"
  kubernetes_version	= "1.28.1"
  dns_prefix			= "myakscluster"
  admin_username		= "azureusr"
  ssh_public_key		= "ssh-rsa AAAAB3Nazcrfwfjwoewejw"
  default_node_count	= 3
  vm_size				= "Standard_D2s_v3"
  os_disk_size 			= 30
  aks_cluster_name		= "DemoAKS"
}

output "kube_config" {
  value 		= module.azure_aks.kube_config
  sensitive		= true
}



# terraform output --raw kube_config > kube_config_output
# kubectl get nodes -o wide
