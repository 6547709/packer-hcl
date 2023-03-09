# ============================ #
# Target vCenter configuration #
# ============================ #
vcenter_server   = "mgmt-vc.corp.local"
vcenter_user     = "Administrator@vsphere.local"
vcenter_password = "VMware1!"
datacenter_name  = "Labs-DC"
datastore_name   = "LUN0-10T"
resource_pool    = "Terraform"
network_name     = "vlan4043"
vm_folder        = "Terraform"
vm_cluster       = "Cluster"

# =========================== #
# Vm configuration #
# =========================== #
vm_template_name = "Rhel84-GUI-100G-latest"
vm_linked_clone  = "false"
linux_user       = "ops"
linux_password   = "VMware1!"
vms = {
  vm-01 = {
    name      = "vm-01"
    ipv4_addr = "192.168.100.61"
    ipv4_mask = 24
    ipv4_gw   = "192.168.100.254"
  },
}
vms-with-disk = {
  vm-db-01 = {
    name      = "vm-db-01"
    ipv4_addr = "192.168.100.62"
    ipv4_mask = 24
    ipv4_gw   = "192.168.100.254"
    disk_index = 1
    disk_size = 20
    thin_provisioned = false
  },
}
hostdnsservers  = ["192.168.100.10"]
hostdomainnames = ["corp.local"]