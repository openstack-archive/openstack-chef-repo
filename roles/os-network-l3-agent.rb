name "os-network-l3-agent"
description "OpenStack network l3-agent service"
run_list(
  "role[os-base]",
  "recipe[openstack-network::l3_agent]"
)

