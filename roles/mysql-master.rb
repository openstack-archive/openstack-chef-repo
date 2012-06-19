name "mysql-master"
description "MySQL Server (non-ha)"
run_list(
  "role[base]",
  "recipe[mysql::server]",
  "recipe[nova::nova-db-monitoring]"
)
