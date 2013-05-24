name "os-identity-api"
description "Keystone API service"
run_list(
  "role[os-base]",
  "recipe[openstack-identity::db]",
  "recipe[openstack-identity::server]"
  )
