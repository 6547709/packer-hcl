terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~>2.3.1"
    }
  }
}

provider "vsphere" {
  user           = var.vcenter_user
  password       = var.vcenter_password
  vsphere_server = var.vcenter_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}


# Data lookups for the source vCenter environment

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter_name
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vm_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

/*data "vsphere_host" "host" {
  name          = var.source_esxi_host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}*/

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# Create VMs
resource "vsphere_virtual_machine" "vms" {
  for_each                   = var.vms
  name                       = each.value.name
  guest_id                   = data.vsphere_virtual_machine.template.guest_id
  resource_pool_id           = data.vsphere_resource_pool.pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  folder                     = var.vm_folder
  firmware                   = "efi"
  efi_secure_boot_enabled    = true
  num_cpus                   = 4
  num_cores_per_socket       = 4
  memory                     = 16384
  wait_for_guest_net_timeout = 0
  nested_hv_enabled          = false
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label            = "disk0"
    unit_number      = 0
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = each.value.name
        domain    = var.hostdomainnames[0]
      }

      network_interface {
        ipv4_address = each.value.ipv4_addr
        ipv4_netmask = each.value.ipv4_mask
      }

      ipv4_gateway    = each.value.ipv4_gw
      dns_server_list = var.hostdnsservers
      dns_suffix_list = var.hostdomainnames
    }
  }
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      resource_pool_id,
      disk,
      folder,
      name,
    ]
  }
}

# Create VMs with disk1
resource "vsphere_virtual_machine" "vms-with-disk" {
  for_each                   = var.vms-with-disk
  name                       = each.value.name
  guest_id                   = data.vsphere_virtual_machine.template.guest_id
  resource_pool_id           = data.vsphere_resource_pool.pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  folder                     = var.vm_folder
  firmware                   = "efi"
  efi_secure_boot_enabled    = true
  num_cpus                   = 8
  num_cores_per_socket       = 8
  memory                     = 32768
  wait_for_guest_net_timeout = 0
  nested_hv_enabled          = false
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label            = "disk0"
    unit_number      = 0
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  disk {
    label            = "disk1"
    size             = each.value.disk_size
    unit_number      = each.value.disk_index
    thin_provisioned = each.value.thin_provisioned
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = each.value.name
        domain    = var.hostdomainnames[0]
      }

      network_interface {
        ipv4_address = each.value.ipv4_addr
        ipv4_netmask = each.value.ipv4_mask
      }

      ipv4_gateway    = each.value.ipv4_gw
      dns_server_list = var.hostdnsservers
      dns_suffix_list = var.hostdomainnames
    }
  }
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      resource_pool_id,
      disk,
      folder,
      name,
    ]
  }
  connection {
    type = "ssh"
    user = var.linux_user
    password= var.linux_password
    host = each.value.ipv4_addr
  }
  provisioner "file" {
    source = "fdisk-sdb.sh"
    destination = "/tmp/fdisk-sdb.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/fdisk-sdb.sh",
      "/tmp/fdisk-sdb.sh /data",
    ]
  }  
}
