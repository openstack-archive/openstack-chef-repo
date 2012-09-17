name "keystone"
description "Keystone server"
run_list(
  "role[base]",
  "recipe[keystone::server]"
)

