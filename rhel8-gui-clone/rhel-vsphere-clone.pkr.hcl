packer {
  required_version = ">= 1.8.4"
  required_plugins {
    vsphere = {
      version = ">= v1.1.0"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}
source "vsphere-clone" "rhel8-clone" {
  CPUs                = var.vm_cpu_num
  cpu_cores           = var.vm_cpu_cores_num
  RAM                 = var.vm_mem_size
  cluster             = var.vsphere_cluster
  content_library_destination {
    destroy = "false"
    library = var.vsphere_content_library
    name    = "${var.vm_name}-latest"
    ovf     = "true"
  }
  convert_to_template = false
  datacenter          = var.vsphere_datacenter
  datastore           = var.vsphere_datastore
  folder              = var.vm_folder
  insecure_connection = "true"
  ip_wait_timeout     = "5m"
  ip_settle_timeout   = "10s"
  ip_wait_address     = "10.0.0.0/8"
  network             = var.vsphere_network
  notes               = "Build via Packer from basic template. Version:${var.template_version} ."
  password            = var.vsphere_password
  ssh_password        = var.linux_ssh_password
  ssh_username        = "root"
  ssh_timeout         = "10m"
  template            = var.vm_template
  username            = var.vsphere_user
  vcenter_server      = var.vsphere_server
  vm_name             = "${var.vm_name}-latest"
}


build {
  sources = ["source.vsphere-clone.rhel8-clone"]
  provisioner "shell" {
    inline = [
      "curl -o /etc/ssh/trusted-CA.pem http://file.corp.oocal/openssh/trusted-CA.pem",
      "sed -i '$a TrustedUserCAKeys /etc/ssh/trusted-CA.pem' /etc/ssh/sshd_config",
      "curl -o /etc/pki/ca-trust/source/anchors/root-ca.pem  http://file.corp.local/ca/root-ca.pem",
      "update-ca-trust",
      "dnf update -y",
      "rm -rf /etc/machine-id /var/lib/dbus/machine-id",
      "touch /etc/machine-id",
      "ln -s /etc/machine-id /var/lib/dbus/machine-id",
      "sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config",
      "rm -rf /etc/issue.d/cockpit.issue /etc/motd.d/cockpit /etc/motd.d/insights-client",
      "ln -s /dev/null  /etc/motd.d/insights-client",
    ]
    pause_before        = "10s"
    start_retry_timeout = "1m"
  }
}
