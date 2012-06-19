name "single-controller"
description "Nova Controller (non-HA)"
run_list(
  "role[base]",
  "role[mysql-master]"
  # "role[rabbitmq-server]",
  # "role[keystone]",
  # "role[glance-registry]",
  # "role[glance-api]",
  # "role[nova-setup]",
  # "role[nova-scheduler]",
  # "role[nova-api-ec2]",
  # "role[nova-api-os-compute]",
  # "role[nova-volume]",
  # "role[nova-vncproxy]",
  # "role[horizon-server]"
)
