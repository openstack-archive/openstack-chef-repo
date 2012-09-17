name "base"
description "Base role for a server"
run_list(
  "recipe[apt]",
  "recipe[openssh]",
  "recipe[ntp]"
)
default_attributes(
  "ntp" => {
    "servers" => ["0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org"]
  },
  "authorization" => {
    "sudo" => {
      "include_sudoers_d" => true
    }
  }
)
