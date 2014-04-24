name "os-telemetry"
description "Role for Ceilometer."
run_list(
  "role[os-telemetry-agent-central]",
  "role[os-telemetry-agent-compute]",
  "role[os-telemetry-agent-notification]",
  "role[os-telemetry-alarm-evaluator]",
  "role[os-telemetry-alarm-notifier]",
  "role[os-telemetry-collector]",
  "role[os-telemetry-api]"
  )
