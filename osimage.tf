
resource "libvirt_volume" "ubuntu-focal" {
  name   = "ubuntu-focal"
  pool   = libvirt_pool.libvirt_lv_pool.name
  source = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_volume" "ubuntu-jammy" {
  name   = "ubuntu-jammy"
  pool   = libvirt_pool.libvirt_lv_pool.name
  source = "https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_volume" "ubuntu-noble" {
  name   = "ubuntu-noble"
  pool   = libvirt_pool.libvirt_lv_pool.name
  source = "https://cloud-images.ubuntu.com/releases/noble/release/ubuntu-24.04-server-cloudimg-amd64.img"
  format = "qcow2"
}


locals {
  # The keys used here for OS and cloud-init need to match in both maps.
  os_table = {
    ubuntu-focal  = libvirt_volume.ubuntu-focal
    ubuntu-jammy  = libvirt_volume.ubuntu-jammy
    ubuntu-noble  = libvirt_volume.ubuntu-noble
  }
  cloud-init_table = {
    ubuntu-focal        = "cloud_init_ubuntu2004.cfg"
    ubuntu-jammy        = "cloud_init_ubuntu2204.cfg"
    ubuntu-noble        = "cloud_init_ubuntu2404.cfg"
  }
}

