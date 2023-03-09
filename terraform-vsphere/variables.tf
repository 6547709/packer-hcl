variable "vcenter_user" {
  description = "Source vCenter Username"
}
variable "vcenter_password" {
  description = "Source vCenter password"
}
variable "vcenter_server" {
  description = "Source vCenter hostname or IP address"
}
variable "linux_user" {
  description = "Set the vms root user"
}
variable "linux_password" {
  description = "Set the vms user password"
}
variable "datacenter_name" {
  description = "Datacenter name in source vCenter"
}
variable "datastore_name" {
  description = "Where to store the  VMs"
}
variable "resource_pool" {
  description = "Specify resource pool for VMs"
}
variable "vm_folder" {
  type        = string
  description = "Specify vm folder"
  default     = "Templates"
}
variable "network_name" {
  description = "Virtual network name"
}
variable "vm_cluster" {
  type        = string
  description = "Specify source cluster name"
}
variable "vms" {
  type        = map(any)
  description = "How many vms do you want to build?"
  default     = {}
}
variable "vms-with-disk" {
  type        = map(any)
  description = "How many vm with disk1 do you want to build?"
  default     = {}
}
variable "vm_template_name" {
  description = "Specify source VM template"
}
variable "vm_linked_clone" {
  type        = string
  description = "Use linked clone to create the vSphere virtual machine from the template (true/false). If you would like to use the linked clone feature, your template need to have one and only one snapshot"
  default     = "false"
}
variable "hostdnsservers" {
  description = "DNS servers for vms"
}
variable "hostdomainnames" {
  description = "DNS suffix for vms"
}
variable "emptystring" {
  description = "Null string - keep default"
  default     = ""
}