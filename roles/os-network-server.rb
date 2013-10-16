name "os-network-server"
description "OpenStack network server service"
run_list(
  "role[os-base]",
  "recipe[openstack-network::server]"
)

