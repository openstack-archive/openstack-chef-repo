name "rabbitmq-server"
description "RabbitMQ Server (non-ha)"
run_list(
  "role[base]",
  "recipe[erlang::default]",
  "recipe[rabbitmq-openstack::server]"
)
default_attributes(
  "rabbitmq" => {
    "use_distro_version" => true
  }
)
