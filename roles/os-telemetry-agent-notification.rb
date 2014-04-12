name "os-telemetry-agent-notification"
description "agent notification for telemetry"
run_list(
  "role[os-base]",
  "recipe[openstack-telemetry::identity_registration]",
  "recipe[openstack-telemetry::agent-notification]"
  )
