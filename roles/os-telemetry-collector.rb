name "os-telemetry-collector"
description "collector for telemetry"
run_list(
  "role[os-base]",
  "recipe[openstack-telemetry::identity_registration]",
  "recipe[openstack-telemetry::collector]"
  )
