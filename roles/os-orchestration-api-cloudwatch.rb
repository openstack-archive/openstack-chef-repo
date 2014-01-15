name "os-orchestration-api-cloudwatch"
description "Role for Heat CloudWatch Api Service."
run_list(
  "role[os-base]",
  "recipe[openstack-orchestration::api-cloudwatch]"
  )
