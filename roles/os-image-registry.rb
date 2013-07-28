name "os-image-registry"
description "Glance Registry service"
run_list(
  "role[os-base]",
  "recipe[openstack-ops-database::openstack-db]",
  "recipe[openstack-image::registry]"
  )
