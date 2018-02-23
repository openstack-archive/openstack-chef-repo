source 'https://supermarket.chef.io'

%w(
  integration-test
  orchestration
  telemetry
  block-storage
  common
  compute
  dashboard
  identity
  image
  network
  ops-database
  ops-messaging
).each do |cookbook|
  if Dir.exist?("../cookbook-openstack-#{cookbook}")
    cookbook "openstack-#{cookbook}", path: "../cookbook-openstack-#{cookbook}"
  else
    cookbook "openstack-#{cookbook}", github: "openstack/cookbook-openstack-#{cookbook}",
                                      branch: 'stable/pike'
  end
end

cookbook 'openstack-dns', github: 'cloudbau/cookbook-openstack-dns', branch: 'stable/pike'
cookbook 'openstackclient', github: 'cloudbau/cookbook-openstackclient', branch: 'stable/pike'
cookbook 'statsd', github: 'librato/statsd-cookbook'
