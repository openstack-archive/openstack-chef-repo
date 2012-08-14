name "nova-scheduler"
description "Nova scheduler"
run_list(
  "role[base]",
  "role[os-database]",
  "role[os-networks]",
  "recipe[nova::scheduler]"
)
