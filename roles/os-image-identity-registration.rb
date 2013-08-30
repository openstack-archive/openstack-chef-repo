name "os-image-identity-registration"
description "Glance identity (keystone) registration"
run_list(
  "role[os-base]",
  "recipe[openstack-image::identity_registration]"
  )

