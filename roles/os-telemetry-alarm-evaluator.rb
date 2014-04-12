name "os-telemetry-alarm-evaluator"
description "alarm evaluator for telemetry"
run_list(
  "role[os-base]",
  "recipe[openstack-telemetry::identity_registration]",
  "recipe[openstack-telemetry::alarm-evaluator]"
  )
