name "lxc"
description "Use lxc for the hypervisor"
override_attributes(
  "nova" => {
    "libvirt" => {
      "virt_type" => "lxc"
    }
  }
)
