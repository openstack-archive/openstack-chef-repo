name "nova-setup"
description "Where the setup operations for nova get run"
run_list(
  "role[base]",
  "recipe[nova::nova-setup]"
)
