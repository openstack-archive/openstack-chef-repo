name 'os-client'
description 'Roll-up role for client interfaces.'
run_list(
  'role[os-base]',
  'recipe[openstack-common::client]',
  'recipe[openstack-identity::client]',
  'recipe[openstack-image::client]',
  'recipe[openstack-network::client]',
  'recipe[openstack-compute::client]',
  'recipe[openstack-orchestration::client]',
  'recipe[openstack-block-storage::client]'
  )
