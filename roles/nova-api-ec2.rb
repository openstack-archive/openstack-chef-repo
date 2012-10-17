name "nova-api-ec2"
description "Nova API EC2"
run_list(
  "role[base]",
  "recipe[nova::api-ec2]"
)
