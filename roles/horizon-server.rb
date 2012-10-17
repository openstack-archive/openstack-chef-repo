name "horizon-server"
description "Horizon server"
run_list(
  "role[base]",
  "recipe[mysql::client]",
  "recipe[horizon::server]"
)
