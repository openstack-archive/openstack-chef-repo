name "os-compute-setup"
description "Nova setup and identity registration"
run_list(
  "role[os-base]",
  "recipe[openstack-compute::nova-setup]",
  "recipe[openstack-compute::identity-registration]"
  )
