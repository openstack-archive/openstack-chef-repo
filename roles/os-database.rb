name "os-database"
description "Define the database settings you're going to use with OpenStack."

override_attributes(
  "mysql" => {
    "allow_remote_root" => true,
    "root_network_acl" => "%"
  }
  )
