terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}



################################################## Providers
provider "libvirt" {
  uri = "qemu:///system"
}

provider "libvirt" {
  alias = "brick2"
  uri = "qemu+ssh://msnow@brick2.example.net/system"
}



################################################## Pools Directories
resource "libvirt_pool" "default" {
  provider = libvirt.brick2
  name = "default"
  type = "dir"
  path = "/var/lib/libvirt/terraform"
}

################################################## Focal Image
resource "libvirt_volume" "focal-base_remote" {
  name   = "focal-base_remote"
  pool   = libvirt_pool.default.name
  source = "/var/lib/libvirt/terraform/base_images/ubuntu-20.04-server-cloudimg-amd64.img"
  format = "qcow2"
}


################################################## Create the libvirt network.
resource "libvirt_network" "vm_network_remote" {
  provider      = libvirt.brick2
  name           = "default"
  mode           = "bridge"
  bridge         = "virbr0"
  autostart      = true
}

#################################################  Cloudinit iso image creation.
resource "libvirt_cloudinit_disk" "commoninit_remote" {
  count          = var.vm_remote_id
  name           = "commoninit_remote_${count.index}.iso"
  pool           = libvirt_pool.default.name
  user_data      = templatefile("${path.module}/cloud_init.cfg", {
                       hostname        = var.machines_remote[count.index]["hostname"]
                       my_user_name    = var.my_user_name,
                       root_pw         = var.root_pw,
                       ssh_pub_key     = var.ssh_pub_key,
                       hostname_prefix = var.hostname_prefix,
                       passwd_hash     = var.passwd_hash
                       })
  network_config = templatefile("${path.module}/network_config.cfg", {
                       dns_domain_one  = var.dns_domain_one,
                       dns_domain_two  = var.dns_domain_two,
                       dns_ip_one      = var.dns_ip_one,
                       dns_ip_two      = var.dns_ip_two,
                       ethernet_if     = var.ethernet_if,
                       ip_bitmask      = var.ip_bitmask,
                       ip_gateway      = var.ip_gateway,
                       ip_addr         = var.machines_remote[count.index]["ip_addr"],
                       })
}



################################################# Volumes for the VMs
resource "libvirt_volume" "vm_volume_remote" {
  provider       = libvirt.brick2
  count          = var.vm_remote_id
  name           = "${var.machines_remote[count.index]["hostname"]}.qcow2"
  base_volume_id = libvirt_volume.focal-base_remote.id
  base_volume_pool = libvirt_pool.default.name
  size           = 30000000000
  pool           = libvirt_pool.default.name
}


################################################# Domain
resource "libvirt_domain" "vm_domain_remote" {
  count = var.vm_remote_id
  name   = "${var.machines_remote[count.index]["hostname"]}"
  memory = "4096"
  vcpu   = "2"
  machine = "q35"
  cloudinit = libvirt_cloudinit_disk.commoninit_remote[count.index].id

  xml {
    xslt = file("cdrom-model.xsl")
  }

  disk {
    volume_id = libvirt_volume.vm_volume_remote[count.index].id
  }

  network_interface {
    network_name  = "default"
    bridge        = "eth0"
    hostname      = var.machines_remote[count.index]["hostname"]
    mac           = var.machines_remote[count.index]["mac"]
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }


  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

}

