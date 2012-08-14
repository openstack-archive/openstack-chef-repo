name "nova-api-ec2"
description "Nova API EC2"
run_list(
  "role[base]",
  "role[os-database]",
  "role[os-networks]",
  "recipe[nova::api-ec2]"
)
