name "os-dashboard"
description "Horizon server"
run_list(
  "role[os-base]",
  "recipe[openstack-ops-database::openstack-db]",
  "recipe[openstack-dashboard::server]"
  )
