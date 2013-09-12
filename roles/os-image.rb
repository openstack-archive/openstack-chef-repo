name "os-image"
description "Roll-up role for Glance."
run_list(
  "recipe[openstack-image::identity_registration]",
  "role[os-image-registry]",
  "role[os-image-api]"
  )
