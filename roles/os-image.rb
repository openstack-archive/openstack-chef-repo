name "os-image"
description "Roll-up role for Glance."
run_list(
  "role[os-image-registry]",
  "role[os-image-identity-registration]",
  "role[os-image-api]"
  )
