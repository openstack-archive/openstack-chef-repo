name "os-telemetry-agent-compute"
description "agent-compute for telemetry"
run_list(
  "role[os-base]",
  "recipe[openstack-telemetry::identity_registration]",
  "recipe[openstack-telemetry::agent-compute]"
  )
