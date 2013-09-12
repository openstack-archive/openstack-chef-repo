name "os-ops-caching"
description "Installs memcache server"
run_list(
  "role[os-base]",
  "recipe[memcached]"
)
