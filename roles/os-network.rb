name "os-network"
description "Configures OpenStack networking, managed by attribute for either nova-network or neutron."
run_list(
  "role[os-base]",
  "recipe[openstack-network::identity_registration]",
  "role[os-network-openvswitch]",
  "role[os-network-l3-agent]",
  "role[os-network-dhcp-agent]",
  "role[os-network-metadata-agent]",
  "role[os-network-server]"
  )
