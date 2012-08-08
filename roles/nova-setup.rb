name "nova-setup"
description "Where the setup operations for nova get run"
run_list(
  "role[base]",
  "role[os-database]",
  "role[os-networks]",
  "recipe[nova::nova-setup]"
)
