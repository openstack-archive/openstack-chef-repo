name "os-block-storage"
description "Configures OpenStack block storage, configured by attributes."
run_list(
  "role[os-base]",
  "recipe[openstack-block-storage::api]",
  "recipe[openstack-block-storage::scheduler]",
  "recipe[openstack-block-storage::volume]",
  "recipe[openstack-block-storage::identity_registration]"
  )
