name "os-metering-agent-compute"
description "agent-compute for metering"
run_list(
  "role[os-base]",
  "recipe[openstack-metering::identity_registration]",
  "recipe[openstack-metering::agent-compute]"
  )
