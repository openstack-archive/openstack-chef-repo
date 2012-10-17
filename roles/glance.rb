name "glance"
description "Glance server"
run_list(
  "role[glance-registry]",
  "role[glance-api]"
)

