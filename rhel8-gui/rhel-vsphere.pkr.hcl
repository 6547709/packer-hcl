packer {
  required_version = ">= 1.8.4"
  required_plugins {
    vsphere = {
      version = ">= v1.1.0"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}
source "vsphere-iso" "rhel8" {
  firmware        = "efi-secure"
  CPUs            = var.vm_cpu_num
  cpu_cores       = var.vm_cpu_cores_num
  RAM             = var.vm_mem_size
  RAM_reserve_all = false
  boot_command = [
    "<up>",
    "e",
    "<down><down><end><wait>",
    " text inst.ks=hd:sr1:/ks.cfg",
    "<enter><wait><leftCtrlOn>x<leftCtrlOff>"
  ]
  boot_order = "disk,cdrom"
  boot_wait  = "10s"
  cluster    = var.vsphere_cluster
  content_library_destination {
    destroy = "false"
    library = var.vsphere_content_library
    name    = "${var.vm_name}-basic"
    ovf     = "true"
  }
  convert_to_template  = false
  datacenter           = var.vsphere_datacenter
  datastore            = var.vsphere_datastore
  disk_controller_type = ["pvscsi"]
  folder               = var.vm_folder
  guest_os_type        = "rhel8_64Guest"
  insecure_connection  = "true"
  ip_wait_timeout      = "60m"
  ip_settle_timeout    = "2m"
  iso_paths            = [var.iso_url]
  cd_files             = ["./ks.cfg"]
  remove_cdrom         = true
  cd_label             = "OEMDRV"
  network_adapters {
    network      = var.vsphere_network
    network_card = "vmxnet3"
  }
  notes        = "Build via Packer, Version:${var.template_version} ."
  password     = var.vsphere_password
  ssh_password = var.linux_ssh_password
  ssh_username = "root"
  ssh_timeout  = "20m"
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = true
  }
  username       = var.vsphere_user
  vcenter_server = var.vsphere_server
  video_ram      = var.vm_video_ram
  vm_name        = "${var.vm_name}-basic"
  vm_version     = var.vm_version
}

build {
  sources = ["source.vsphere-iso.rhel8"]
  provisioner "shell" {
    inline = [
      "echo 'exclude=redhat-release*' >> /etc/yum.conf",
      "echo 'exclude=redhat-release*' >> /etc/dnf/dnf.conf",
      "dnf remove cups -y",
      "dnf update -y",
      "rm -rf /root/*.cfg",
      "dnf autoremove -y",
      "dnf clean all -y",
      "rm -rf /root/.ssh /home/ops/.ssh",
      "rm -rf /etc/ssh/*_key /etc/ssh/*.pub",
      "rm -rf /tmp/*",
      "sed -i 's/^HISTSIZE=1000/HISTSIZE=5000/' /etc/profile",
      "sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/subscription-manager.conf",
      "sed -i 's/enabled=1/enabled=0/g' /etc/dnf/plugins/subscription-manager.conf",
      "sed -i 's/^Exec=.*/#&/g' /etc/xdg/autostart/org.gnome.SettingsDaemon.Subscription.desktop",
      "dnf -y remove subscription-manager-cockpit",
      "rm -rf /etc/machine-id /var/lib/dbus/machine-id",
      "touch /etc/machine-id",
      "ln -s /etc/machine-id /var/lib/dbus/machine-id",
      "timedatectl set-timezone Asia/Shanghai",
      "cat /dev/null > /var/log/wtmp /var/log/lastlog /var/log/messages",
    ]
    pause_before        = "10s"
    start_retry_timeout = "1m"
  }
}
