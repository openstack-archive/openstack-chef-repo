name "os-compute-conductor"
description "Nova conductor"
run_list(
  "role[os-base]",
  "recipe[openstack-compute::conductor]"
  )
