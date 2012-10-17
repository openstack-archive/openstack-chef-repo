name "glance-api"
description "Glance API server"
run_list(
  "role[base]",
  "recipe[glance::api]"
)

