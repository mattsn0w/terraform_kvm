
resource "libvirt_volume" "ubuntu-noble" {
  name   = "ubuntu-noble"
  pool   = libvirt_pool.libvirt_lv_pool.name
  source = "https://cloud-images.ubuntu.com/releases/noble/release/ubuntu-24.04-server-cloudimg-amd64.img"
  format = "qcow2"
}


locals {
  # The keys used here for OS and cloud-init need to match in both maps.
  os_table = {
    ubuntu-noble  = libvirt_volume.ubuntu-noble
  }
  cloud-init_table = {
    ubuntu-noble        = "cloud_init_ubuntu2404.cfg"
  }
}

