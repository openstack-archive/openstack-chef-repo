name "os-metering-api"
description "api for metering"
run_list(
  "role[os-base]",
  "recipe[openstack-metering::identity_registration]",
  "recipe[openstack-metering::api]"
  )
