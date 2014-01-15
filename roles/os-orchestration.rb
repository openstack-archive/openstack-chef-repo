name "os-orchestration"
description "Role for Heat."
run_list(
  "role[os-orchestration-engine]",
  "role[os-orchestration-api]",
  "role[os-orchestration-api-cfn]",
  "role[os-orchestration-api-cloudwatch]",
  "recipe[openstack-orchestration::identity_registration]"
  )
