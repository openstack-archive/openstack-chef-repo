name "os-network-openvswitch"
description "OpenStack network openvswitch service"
run_list(
  "role[os-base]",
  "recipe[openstack-network::openvswitch]"
)

