// vSphere Credentials
variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance. (e.g. 'mgmt-vc.corp.local')"
}
variable "vsphere_user" {
  type        = string
  description = "The username to login to the vCenter Server instance. (e.g. 'svc-packer-vsphere@corp.local')"
  sensitive   = true
}
variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
  sensitive   = true
}
variable "vsphere_insecure_connection" {
  type        = bool
  description = "Do not validate vCenter Server TLS certificate."
  default     = true
}

// vSphere Settings
variable "vsphere_datacenter" {
  type        = string
  description = "The name of the target vSphere datacenter. (e.g. 'dc02')"
}
variable "vsphere_cluster" {
  type        = string
  description = "The name of the target vSphere cluster. (e.g. 'dc02-cluster')"
}
variable "vsphere_datastore" {
  type        = string
  description = "The name of the target vSphere datastore. (e.g. 'FC-LUN0')"
}
variable "vsphere_content_library" {
  type        = string
  description = "The name of the target content library. (e.g. 'dc02-vm-templates')"
}
variable "vsphere_network" {
  type        = string
  description = "The name of the target vSphere network segment. (e.g. 'VLAN4041')"
}
variable "vm_folder" {
  type        = string
  description = "The name of the target vSphere folder. (e.g. 'templates')"
}


// Virtual Machine Settings
variable "linux_ssh_password" {
  type        = string
  description = "The password to login to the guest operating system."
  sensitive   = true
}

variable "template_version" {
  type        = string
  description = "The version of the template."
}

variable "vm_cpu_num" {
  type        = string
  description = "The number of virtual CPUs. (e.g. '2')"
}

variable "vm_cpu_cores_num" {
  type        = string
  description = "The number of virtual CPU cores.(eg. '4')"
}

variable "vm_mem_size" {
  type        = string
  description = "The size for the virtual memory in MB. (e.g. '2048')"
}

variable "vm_name" {
  type        = string
  description = "The number of vm template. (e.g. 'Centos-T')"
}

variable "vm_template" {
  type        = string
  description = "The vm template name. (e.g. 'Rhel8-GUI-latest')"
}
