terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

provider "libvirt" {
  uri = "${var.qemu_uri_path}"
}

# The libvirt pool. This needs to be defined at the root module level, then passed into the module
#   as an input variable to prevent the for_each from recursively creating a storage pool for each 
#   VM in the machines map.
resource "libvirt_pool" "libvirt_lv_pool" {
  name = "libvirt_lv_pool"
  type = "dir"
  target {
    path = "/var/lib/libvirt/terraform/pool"
  }
}

resource "libvirt_network" "default" {
  name = "default"
  mode = "bridge"
  bridge = "virbr0"
}



module "libvirt_machine_instance" {
  source              = "./modules/libvirt_machine"
  hypervisor_host     = "${var.hypervisor_host}"
  qemu_uri_path       = "${var.qemu_uri_path}"
  ip_gateway          = "${var.ip_gateway}"
  hostname_prefix     = "${var.hostname_prefix}"
  ethernet_if         = "enp1s0"
  libvirt-pool-name   = libvirt_pool.libvirt_lv_pool
  os-images           = local.os_table

  for_each = var.machines
  machines = {
    "${each.key}" = {
      hostname        = each.value.hostname
      ip_addr         = each.value.ip_addr
      disk_size       = each.value.disk_size
      memory          = each.value.memory
      vcpu            = each.value.vcpu
      machine_type    = each.value.machine_type
      os              = lookup(local.os_table, each.value.os)
      cloud-init      = lookup(local.cloud-init_table, each.value.os)
      network_config  = each.value.network_config
    }
  }
}

