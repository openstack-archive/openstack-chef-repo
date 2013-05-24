name "os-network"
description "Configures OpenStack networking, managed by attribute for either nova-network or quantum"
run_list(
  "role[os-base]",
  "recipe[openstack-network]"
  )
