source 'https://supermarket.chef.io'

%w(
  integration-test
  orchestration
  telemetry
  block-storage
  common
  compute
  dashboard
  dns
  identity
  image
  network
  ops-database
  ops-messaging
).each do |cookbook|
  if Dir.exist?("../cookbook-openstack-#{cookbook}")
    cookbook "openstack-#{cookbook}", path: "../cookbook-openstack-#{cookbook}"
  else
    cookbook "openstack-#{cookbook}", git: "https://git.openstack.org/openstack/cookbook-openstack-#{cookbook}"
  end
end

cookbook 'openstackclient', git: 'https://git.openstack.org/openstack/cookbook-openstackclient'
cookbook 'statsd', github: 'librato/statsd-cookbook'
