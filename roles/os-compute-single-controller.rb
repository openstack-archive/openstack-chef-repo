name "os-compute-single-controller"
description "Roll-up role for all of the OpenStack Compute services on a single, non-HA controller."
run_list(
  "role[os-base]",
  "role[os-ops-database]",
  "role[os-ops-messaging]",
  "role[os-identity]",
  "role[os-image]",
  "role[os-network]",
  "role[os-compute-scheduler]",
  "role[os-compute-api]",
  "role[os-block-storage]",
  "role[os-compute-cert]",
  "role[os-compute-vncproxy]",
  "role[os-dashboard]"
  )
