# main.tf
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }
}

resource "libvirt_volume" "vm_volume" {
  for_each = var.machines
  name           = "${each.value.hostname}.qcow2"
  base_volume_id = each.value.os.id
  size           = each.value.disk_size
  pool           = var.libvirt-pool-name.name

  lifecycle {
    ignore_changes = [ size ]
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  for_each = var.machines
  name           = "commoninit.${each.value.hostname}.iso"
  user_data      = templatefile("${path.module}/../../templates/${each.value.cloud-init}", { 
                       hostname        = each.value.hostname
                       my_user_name    = var.my_user_name, 
                       root_pw         = var.root_pw, 
                       ssh_pub_key     = var.ssh_pub_key, 
                       hostname_prefix = var.hostname_prefix,
                       passwd_hash     = var.passwd_hash
                       } )
  network_config = templatefile("${path.module}/../../templates/${each.value.network_config}", {
                       dns_domain_one  = var.dns_domain_one,
                       dns_domain_two  = var.dns_domain_two,
                       dns_ip_one      = var.dns_ip_one,
                       dns_ip_two      = var.dns_ip_two,
                       ethernet_if     = var.ethernet_if,
                       ip_bitmask      = var.ip_bitmask,
                       ip_gateway      = var.ip_gateway,
                       ip_addr         = each.value.ip_addr,
                       } )
  pool           = var.libvirt-pool-name.name

  lifecycle {
    ignore_changes = [ name, user_data, network_config ]
  }
}


resource "libvirt_domain" "vm_domain" {
  for_each = var.machines

  arch      = "x86_64"
  name      = "${each.value.hostname}"
  memory    = "${each.value.memory}"
  vcpu      = "${each.value.vcpu}"
  machine   = "${each.value.machine_type}"
  cloudinit = libvirt_cloudinit_disk.commoninit[each.key].id
  autostart = true

  lifecycle {
    ignore_changes = [ memory, vcpu, network_interface ]
  }
  
  cpu {
    mode = "host-passthrough"
  }

  xml { xslt = file("cdrom-model.xsl") }

  disk {
    volume_id = libvirt_volume.vm_volume[each.key].id
  }

  network_interface {
    network_name  = "default"
    bridge        = "virbr0"
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

