name "os-networks"
description "Define the networks you're going to use with OpenStack. These will be used in the libraries provided by the osops-utils cookbook. This example is "

override_attributes(
  "osops_networks" => {
    "public" => "10.0.111.0/24",
    "management" => "192.168.1.0/24",
    "nova" => "10.0.111.0/24"
  },
  "nova" => {
    "networks" => [
      {
        "label" => "public",
        "ipv4_cidr" => "10.0.100.0/24",
        "num_networks" => "1",
        "network_size" => "255",
        "bridge" => "br100",
        "bridge_dev" => "eth0.100",
        "dns1" => "8.8.8.8",
        "dns2" => "8.8.4.4"
      },
      {
        "label" => "private",
        "ipv4_cidr" => "10.0.200.0/24",
        "num_networks" => "1",
        "network_size" => "255",
        "bridge" => "br101",
        "bridge_dev" => "eth0.101",
        "dns1" => "8.8.8.8",
        "dns2" => "8.8.4.4"
      }
    ]
  }
  )
