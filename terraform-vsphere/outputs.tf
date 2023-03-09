output "vms_ip_addresses" {
  value = values(vsphere_virtual_machine.vms).*.guest_ip_addresses[0]
}
output "vms-with-disk_ip_addresses" {
  value = values(vsphere_virtual_machine.vms-with-disk).*.guest_ip_addresses[0]
}
output "linux_password" {
  value = var.linux_password
}
output "linux_user" {
  value = var.linux_user
}
