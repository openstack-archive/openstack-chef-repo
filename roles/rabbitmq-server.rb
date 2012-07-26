name "rabbitmq-server"
description "RabbitMQ Server (non-ha)"
run_list(
  "role[base]",
  "recipe[apt]",
  "recipe[erlang::default]",
  "recipe[rabbitmq::default]"
)
