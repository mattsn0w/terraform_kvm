# Fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "focal-base" {
  name   = "focal-base"
  pool   = libvirt_pool.tfpool.name
  #source = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
  source = "/var/lib/libvirt/terraform/base_images/ubuntu-20.04-server-cloudimg-amd64.img"
  format = "qcow2"
}