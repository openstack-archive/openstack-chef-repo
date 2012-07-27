name "os-database"
description "Define the database settings you're going to use with OpenStack."
run_list(
  "recipe[build-essential]"
  )

override_attributes(
  "mysql" => {
    "allow_remote_root" => true,
    "root_network_acl" => "%"
  },
  "build-essential" => {
    "compiletime" => true
  }
  )
