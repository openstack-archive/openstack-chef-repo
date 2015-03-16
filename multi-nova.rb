require 'chef/provisioning'

controller_config = <<-ENDCONFIG
  config.vm.network "forwarded_port", guest: 443, host: 9443 # dashboard-ssl
  config.vm.network "forwarded_port", guest: 4002, host: 4002
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 6080, host: 6080
  config.vm.network "forwarded_port", guest: 8773, host: 8773 # compute-ec2-api
  config.vm.network "forwarded_port", guest: 8774, host: 8774 # compute-api
  config.vm.network "forwarded_port", guest: 35357, host: 35357
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
    v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.vm.network "public_network", ip: "172.16.100.60",
    bridge: '<put your interface device name here>'
ENDCONFIG

machine 'controller' do
  add_machine_options vagrant_config: controller_config
  role 'os-compute-single-controller'
  recipe 'openstack-network::identity_registration'
  role 'os-network-dhcp-agent'
  role 'os-network-metadata-agent'
  role 'os-network-server'
  recipe 'openstack-common::openrc'
  recipe 'openstack-integration-test::setup'
  # if you would like to use centos7 you'll need to
  # use 'vagrant-multi-centos7-nova' for the environment
  chef_environment 'vagrant-multi-nova'
  file('/etc/chef/openstack_data_bag_secret',
       "#{File.dirname(__FILE__)}/.chef/encrypted_data_bag_secret")
  converge true
end

machine_batch do
  [%w(compute1 61), %w(compute2 62), %w(compute3 63)].each do |name, ip_suff|
    machine name do
      add_machine_options vagrant_config: <<-ENDCONFIG
config.vm.provider "virtualbox" do |v|
  v.memory = 2048
  v.cpus = 2
  v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
  v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
  v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
end
config.vm.network "public_network", ip: "172.16.100.#{ip_suff}",
  bridge: '<put your interface device name here>'
ENDCONFIG
      role 'os-compute-worker'
      # if you would like to use centos7 you'll need to
      # use 'vagrant-multi-centos7-nova' for the environment
      chef_environment 'vagrant-multi-nova'
      file('/etc/chef/openstack_data_bag_secret',
           "#{File.dirname(__FILE__)}/.chef/encrypted_data_bag_secret")
      converge true
    end
  end
end
