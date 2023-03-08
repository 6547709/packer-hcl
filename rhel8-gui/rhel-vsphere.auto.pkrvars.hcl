/*
    DESCRIPTION:
    Redhat Enterprise Linux 8 variables used by the Packer Plugin for VMware vSphere (vsphere-iso).
*/
// vSphere Config
vsphere_server          = "mgmt-vc.corp.local"
vsphere_user            = "Administrator@vsphere.local"
vsphere_password        = "VMware1!"
vsphere_datacenter      = "Labs-DC"
vsphere_cluster         = "Cluster"
vsphere_content_library = "VM-Templates"
vm_folder               = "Templates"
vsphere_datastore       = "LUN0-10T"

// Rocky Install Media
iso_url = "[LUN0-10T] 0-ISO/rhel-8.4-x86_64-dvd.iso"

// Virtual Machine Hardware Settings
template_version = "1.0.0"
vm_name          = "Rhel84-GUI-100G"
vsphere_network  = "vlan4043"
vm_cpu_num       = 4
vm_cpu_cores_num = 4
vm_mem_size      = 8192
vm_disk_size     = 102400
vm_video_ram     = 8192
vm_version       = 19

//Guest Operating System Metada
linux_ssh_password = "VMware1!"
