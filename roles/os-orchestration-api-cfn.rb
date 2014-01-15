name "os-orchestration-api-cfn"
description "Role for Heat CloudFormation Api Service."
run_list(
  "role[os-base]",
  "recipe[openstack-orchestration::api-cfn]"
  )
