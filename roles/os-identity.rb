name "os-identity"
description "Roll-up role for Identity"
run_list(
  "role[os-base]",
  "recipe[openstack-identity::db]",
  "recipe[openstack-identity::server]",
  "recipe[openstack-identity::registration]"
  )
