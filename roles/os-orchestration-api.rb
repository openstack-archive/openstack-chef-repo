name "os-orchestration-api"
description "Role for Heat Api Service."
run_list(
  "role[os-base]",
  "recipe[openstack-orchestration::api]"
  )
