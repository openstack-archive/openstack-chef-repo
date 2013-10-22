name "os-network-dhcp-agent"
description "OpenStack network dhcp-agent service"
run_list(
  "role[os-base]",
  "recipe[openstack-network::dhcp_agent]"
)

