name "nova-volume"
description "Nova Volume Service"
run_list(
  "role[base]",
  "recipe[nova::volume]"
)
