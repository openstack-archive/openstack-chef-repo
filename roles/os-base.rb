name "os-base"
description "OpenStack Base role"
run_list(
  "recipe[openstack-common]",
  "recipe[openstack-common::logging]",
  "recipe[openstack-common::set_endpoints_by_interface]",
  "recipe[openstack-common::sysctl]"
)
