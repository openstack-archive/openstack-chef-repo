name "os-network-metadata-agent"
description "OpenStack network metadata-agent service"
run_list(
  "role[os-base]",
  "recipe[openstack-network::metadata_agent]"
)
