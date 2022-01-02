root_pw = "a_plain_text_root_pw"
my_user_name = "myusername"
passwd_hash = "<insert_hash_generated_from: echo -n 'my_password' | mkpasswd -m sha-512 -s>"
ssh_pub_key = "self explanatory"

# Local vms to create on brick/nuc box.
vm_id = 1

# Remote VMs to create on brick2/1LPC
vm_remote_id = 3

ethernet_if = "enp1s0"

# Name Resolution , DNS, and IP Alloc info
hostname_prefix = "kvm"

dns_domain_name = "home.example.net"

# Your DNS Search domains
dns_domain_one  = "home.example.net"
dns_domain_two  = "example.net"
dns_ip_one      = "172.16.1.1"
dns_ip_two      = "172.16.1.2"

ip_bitmask = "24"
ip_gateway = "172.16.1.254"

# The VMs that we will create. MAC addresses are defined since we have a static DHCP assignment.
machines = [
    {
    hostname = "legvm1.home.example.net"
    mac      = "56:6f:4f:c1:00:01"
    ip_addr  = "172.16.1.11"
    },
]
machines_remote = [
    {
    hostname = "legvm2.home.example.net"
    mac      = "56:6f:4f:c1:00:02"
    ip_addr  = "172.16.1.12"
    },
    {
    hostname = "legvm3.home.example.net"
    mac     = "56:6f:4f:c1:00:03"
    ip_addr = "172.16.1.13"
    },
    {
    hostname = "legvm4.home.example.net"
    mac     = "56:6f:4f:c1:00:04"
    ip_addr = "172.16.1.14"
    }
]

