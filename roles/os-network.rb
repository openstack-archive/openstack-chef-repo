name "os-network"
description "Configures OpenStack networking, managed by attribute for either nova-network or quantum"
run_list(
  "role[os-base]",
  "recipe[openstack-network::identity_registration]",
  "role[os-network-server]",
  "role[os-network-openvswitch]",
  "role[os-network-l3-agent]",
  "role[os-network-dhcp-agent]",
  "role[os-network-metadata-agent]"
  )
