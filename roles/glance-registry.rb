name "glance-registry"
description "Glance Registry server"
run_list(
  "role[base]",
  "role[os-database]",
  "role[os-networks]",
  "recipe[glance::registry]"
)

