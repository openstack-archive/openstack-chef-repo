name "keystone"
description "Keystone server"
run_list(
  "role[base]",
  "role[os-database]",
  "role[os-networks]",
  "recipe[keystone::server]"
)

