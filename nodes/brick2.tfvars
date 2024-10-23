
hypervisor_host = "brick2.co.slakin.net"
qemu_uri_path = "qemu+ssh://root@brick2.co.slakin.net/system?keyfile=/home/msnow/.ssh/id_rsa"
ip_gateway = "172.16.1.254"
hostname_prefix = "legvm"

machines = {
    "legvm2" = {
      hostname     = "legvm2.co.slakin.net"
      mac          = "de:ad:be:ef:1d:62"
      ip_addr      = "172.16.1.62"
      disk_size    = 50000000000
      memory       = 4096
      vcpu         = 2
      machine_type = "q35"
      os           = "ubuntu-noble"
      cloud-init   = "ubuntu-noble"
      network_config = "network_config_ubuntu.cfg"
    },

    "legvm3" = {
      hostname     = "legvm3.co.slakin.net"
      mac          = "de:ad:be:ef:1d:63"
      ip_addr      = "172.16.1.63"
      disk_size    = 50000000000
      memory       = 4096
      vcpu         = 2
      machine_type = "q35"
      os           = "ubuntu-noble"
      cloud-init   = "ubuntu-noble"
      network_config = "network_config_ubuntu.cfg"
    },

    "legvm4" = {
      hostname     = "legvm4.co.slakin.net"
      mac          = "de:ad:be:ef:1d:63"
      ip_addr      = "172.16.1.66"
      disk_size    = 50000000000
      memory       = 4096
      vcpu         = 2
      machine_type = "q35"
      os           = "ubuntu-noble"
      cloud-init   = "ubuntu-noble"
      network_config = "network_config_ubuntu.cfg"
   },
  }

