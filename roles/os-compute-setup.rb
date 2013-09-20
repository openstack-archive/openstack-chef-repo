name "os-compute-setup"
description "Nova setup and identity registration"
run_list(
  "role[os-base]",
  "recipe[openstack-compute::setup]",
  "recipe[openstack-compute::identity-registration]"
  )
