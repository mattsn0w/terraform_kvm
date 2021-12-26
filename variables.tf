
variable "vm_id" {
  type        = number
  default     = 3
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