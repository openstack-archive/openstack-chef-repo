name "lxc"
description "Use lxc for the hypervisor"

run_list(
  "recipe[lxc]"
  )

override_attributes(
  "nova" => {
    "libvirt" => {
      "virt_type" => "lxc"
    }
  },
  "lxc" => {
    "packages" => ['lxc', 'libvirt-bin'],
    "addr" => '10.0.98.1',
    "network" => '10.0.98.0/24',
    "dhcp_range" => '10.0.98.2,10.0.98.254',
    "containers" => {
      "example" => {
        "template" => "ubuntu"
      }
    }
  }
)

