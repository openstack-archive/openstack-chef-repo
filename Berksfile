source 'https://supermarket.chef.io'

%w(
    bare-metal
    database
    data-processing
    integration-test
    object-storage
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
  if ENV['ZUUL_CHANGES'] && Dir.exist?("../cookbook-openstack-#{cookbook}")
    cookbook "openstack-#{cookbook}", path: "../cookbook-openstack-#{cookbook}"
  else
    cookbook "openstack-#{cookbook}", github: "openstack/cookbook-openstack-#{cookbook}"
  end
end

cookbook 'apache2', '3.2.0'
cookbook 'apt', '2.8.2'
cookbook 'aws', '2.1.1'
cookbook 'build-essential', '2.1.3'
cookbook 'ceph', '0.9.2'
cookbook 'database', '4.0.2'
cookbook 'erlang', '1.5.8'
cookbook 'mariadb', '0.3.1'
cookbook 'memcached', '1.7.2'
cookbook 'mysql', '6.0.13'
cookbook 'mysql2_chef_gem', '1.0.1'
cookbook 'openssl', '4.0.0'
cookbook 'postgresql', '3.4.18'
cookbook 'python', '1.4.6'
cookbook 'rabbitmq', '4.2.2'
cookbook 'xfs', '1.1.0'
cookbook 'yum', '3.5.4'
cookbook 'selinux', '0.9.0'
cookbook 'yum-epel', '0.6.0'
cookbook 'statsd', github: 'att-cloud/cookbook-statsd'
