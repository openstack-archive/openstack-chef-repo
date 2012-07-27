name "glance-api"
description "Glance API server"
run_list(
  "role[base]",
  "role[os-networks]",
  "recipe[glance::api]"
)

