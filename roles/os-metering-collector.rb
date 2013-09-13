name "os-metering-collector"
description "collector for metering"
run_list(
  "role[os-base]",
  "recipe[openstack-metering::identity_registration]",
  "recipe[openstack-metering::collector]"
  )
