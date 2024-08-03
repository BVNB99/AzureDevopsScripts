variable "resource_group_name" {
  description 	= "Name of the resource group"
  type			= string
}

variable "location" {
  description	= "Azure location for the resources"
  type			= string
}

variable "vnet_name" {
  description 	= "Name of the virtual network"
  type			= string
}

variable "vnet_address_space" {
  description 	= "Address space for the virtual network"
  type			= string
}

variable "subnet_name" {
  description	= "Name of the subnet"
  type			= string
}

variable "subnet_prefix" {
  description 	= "Prefix for the subnet"
  type			= string
}

variable "nic_name" {
  description 	= "Name of the network interface"
  type			= string
}

variable "no_of_vms" {
  description	= "Name of the virtual machine"
  type			= number
}

variable "vm_size" {
  description 	= "Size of the virtual machine"
  type 			= string
}

variable "disk_type" {
  description   = "Storage disk type"
  type		= string
}

variable "disk_name" {
  description   = "Storage disk name"
  type          = string
}

variable "admin_username" {
  description 	= "Admin username for the vm"
  type			= string
}

variable "admin_password" {
  description 	= "Admin password for the vm"
  type			= string
}

#variable "path" {
#  description 	= "Path for SSH keys"
#  type			= string
#}
#
#variable "key_data" {
#  description 	= "Public ssh keys"
#  type			= string
#}
