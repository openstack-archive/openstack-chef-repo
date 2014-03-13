name "os-telemetry-agent-central"
description "agent-central for telemetry"
run_list(
  "role[os-base]",
  "recipe[openstack-telemetry::identity_registration]",
  "recipe[openstack-telemetry::agent-central]"
  )
