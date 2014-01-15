name "os-orchestration-engine"
description "Role for Heat Engine Service."
run_list(
  "role[os-base]",
  "recipe[openstack-orchestration::engine]"
  )
