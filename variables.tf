
variable "vm_id" {
  type        = number
  default     = 1
  description = "The number of KVM instances to create."
}

variable "root_pw" {
  type = string
}

variable "passwd_hash" {
  type = string
}

variable "ssh_pub_key" {
  type = string
}

variable "my_user_name" {
  type = string
}

variable "dns_domain_name" {
  type = string
}

variable "dns_domain_one" {}
variable "dns_domain_two" {}
variable "dns_ip_one" {}
variable "dns_ip_two" {}
variable "ip_bitmask" {}
variable "ip_gateway" {}
variable "ethernet_if" {}

variable "hostname_prefix" {
  type = string
}

variable "machines" {
  type = list(object({
    hostname = string
    mac      = string
    ip_addr  = string
  }))
}

