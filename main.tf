terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  # Configuration options
  uri = "qemu:///system"
}

resource "libvirt_pool" "tfpool" {
  name = "tfpool"
  type = "dir"
  path = "/var/lib/libvirt/terraform/pool"
}

resource "libvirt_volume" "vm_volume" {
  count          = var.vm_id
  name           = "${var.machines[count.index]["hostname"]}.qcow2"
  base_volume_id = libvirt_volume.focal-base.id
  size           = 30000000000 
  pool           = libvirt_pool.tfpool.name
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count          = var.vm_id
  name           = "commoninit${count.index}.iso"
  user_data      = templatefile("${path.module}/cloud_init.cfg", { 
                       hostname        = var.machines[count.index]["hostname"]
                       my_user_name    = var.my_user_name, 
                       root_pw         = var.root_pw, 
                       ssh_pub_key     = var.ssh_pub_key, 
                       hostname_prefix = var.hostname_prefix,
                       passwd_hash     = var.passwd_hash
                       } )
  network_config = templatefile("${path.module}/network_config.cfg", {
                       dns_domain_one  = var.dns_domain_one,
                       dns_domain_two  = var.dns_domain_two,
                       dns_ip_one      = var.dns_ip_one,
                       dns_ip_two      = var.dns_ip_two,
                       ethernet_if     = var.ethernet_if,
                       ip_bitmask      = var.ip_bitmask,
                       ip_gateway      = var.ip_gateway,
                       ip_addr         = var.machines[count.index]["ip_addr"],
                       } )
  pool           = libvirt_pool.tfpool.name
}

# Create the libvirt network.
resource "libvirt_network" "vm_network" {
  name           = "default"
  mode           = "bridge"
  bridge         = "virbr0"
  autostart      = true
}


resource "libvirt_domain" "vm_domain" {
  count = var.vm_id
  name   = "${var.machines[count.index]["hostname"]}"
  memory = "2048"
  vcpu   = "2"
  machine = "q35"
  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id
  
  xml {
    xslt = file("cdrom-model.xsl")
  }

  disk {
    volume_id = libvirt_volume.vm_volume[count.index].id
  }

  network_interface {
    network_name  = "default"
    bridge        = "eth0"
    mac           = var.machines[count.index]["mac"]
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

