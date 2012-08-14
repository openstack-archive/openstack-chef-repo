name "nova-vncproxy"
description "Nova VNC Proxy"
run_list(
  "role[base]",
  "role[os-database]",
  "role[os-networks]",
  "recipe[nova::vncproxy]"
)

