name "os-compute-identity-registration"
description "Nova identity (keystone) registration"
run_list(
  "role[os-base]",
  "recipe[openstack-compute::identity_registration]"
  )
