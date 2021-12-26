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

resource "libvirt_volume" "tfvm" {
  count          = var.vm_id
  name           = "tfvm${count.index}.qcow2"
  base_volume_id = libvirt_volume.focal-base.id
  size           = 30000000000 
  pool           = libvirt_pool.tfpool.name
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count = var.vm_id
  name           = "commoninit${count.index}.iso"
  user_data      = templatefile("${path.module}/cloud_init.cfg", {instance = count.index, my_user_name = var.my_user_name, root_pw = var.root_pw, ssh_pub_key = var.ssh_pub_key, passwd_hash = var.passwd_hash} )
  network_config = templatefile("${path.module}/network_config.cfg", {instance = count.index} )
  pool           = libvirt_pool.tfpool.name
}

resource "libvirt_domain" "tfvm" {
  count = var.vm_id
  name   = "tfvm${count.index}.lt.co.slakin.net"
  memory = "1024"
  vcpu   = "1"
  machine = "q35"
  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id
  
  xml {
    xslt = file("cdrom-model.xsl")
  }

  disk {
    volume_id = libvirt_volume.tfvm[count.index].id
  }

  network_interface {
    network_name    = "default"
    bridge          = "eth0"
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

