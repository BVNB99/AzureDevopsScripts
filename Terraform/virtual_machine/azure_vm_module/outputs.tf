output "vm_id" {
  description   = "The id of the virtual machine"
  value                 = azurerm_virtual_machine.vm_1[*].id
}
