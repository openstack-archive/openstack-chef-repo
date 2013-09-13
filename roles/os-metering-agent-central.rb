name "os-metering-agent-central"
description "agent-central for metering"
run_list(
  "role[os-base]",
  "recipe[openstack-metering::identity_registration]",
  "recipe[openstack-metering::agent-central]"
  )
