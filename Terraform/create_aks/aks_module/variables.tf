variable "aks_cluster_name" {
  description 	= "The name of the AKS cluster"
  type			= string
}

variable "location" {
  description 	= "The azure region to deploy to"
  type			= string
}


variable "resource_group_name" {
  description 	= "The name of the resource group"
  type			= string
}


variable "dns_prefix" {
  description 	= "The DNS prefix for the AKS cluster"
  type			= string
}

variable "admin_username" {
  description	= "The admin username for the AKS nodes"
  type			= string
}

variable "ssh_public_key" {
  description 	= "The SSH public key"
  type			= string
}

variable "default_node_count" {
  description 	= "The number of nodes in the default node pool"
  type			= number
  default		= 3
}

variable "vm_size" {
  description 	= "The size of the VMs in the default node pool"
  default		= "Standard_DS2_v2"
}

variable "kubernetes_version" {
  description 	= "The kubernetes version"
  default 		= "1.28.1"
}

variable "os_disk_size" {
  description 	= "OS Disk size"
}

variable "tags" {
  description 	= "Tags to apply to resources"
  type			= map(string)
  default		= {
    environment	= "dev"
	project 	= "terraform-aks"
  }
}
