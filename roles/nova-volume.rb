name "nova-volume"
description "Nova Volume Service"
run_list(
  "role[base]",
  "role[os-database]",
  "role[os-networks]",
  "recipe[nova::volume]"
)
