name "glance-registry"
description "Glance Registry server"
run_list(
  "role[base]",
  "recipe[glance::registry]"
)

