name "os-telemetry-alarm-notifier"
description "alarm notifier for telemetry"
run_list(
  "role[os-base]",
  "recipe[openstack-telemetry::identity_registration]",
  "recipe[openstack-telemetry::alarm-notifier]"
  )
