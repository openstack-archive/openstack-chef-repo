name "nova-api-os-compute"
description "Nova API for Compute"
run_list(
  "role[base]",
  "role[os-database]",
  "role[os-networks]",
  "recipe[nova::api-os-compute]"
)
