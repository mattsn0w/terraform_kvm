# outputs.tf

output "libvirt_domain" {
    description = "The domain object for libvirt to create"
    value       = libvirt_domain.vm_domain
}


output "libvirt_volume" {
    description = "The vm_volume of a domain"
    value       = libvirt_volume.vm_volume
}

output "libvirt_cloudinit_disk" {
  description = "The cloud-init disk iso file"
  value       = libvirt_cloudinit_disk.commoninit
}

