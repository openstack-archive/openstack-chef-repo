name "nova-api-os-compute"
description "Nova API for Compute"
run_list(
  "role[base]",
  "recipe[nova::api-os-compute]"
)
