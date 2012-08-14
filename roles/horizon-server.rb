name "horizon-server"
description "Horizon server"
run_list(
  "role[base]",
  "role[os-database]",
  "role[os-networks]",
  "recipe[mysql::client]",
  "recipe[horizon::server]"
)
