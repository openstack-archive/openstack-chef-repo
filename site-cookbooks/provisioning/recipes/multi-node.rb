require 'chef/provisioning'

# config for controller-node vagrant box
controller_config = <<-ENDCONFIG
  config.vm.network "forwarded_port", guest: 443, host: 9443 # dashboard-ssl
  config.vm.network "forwarded_port", guest: 4002, host: 4002
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 8774, host: 8774 # compute-api
  config.vm.network "forwarded_port", guest: 35357, host: 35357
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
    v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.vm.network "private_network", ip: "192.168.100.60"
  config.vm.network "private_network", ip: "192.168.101.60"
ENDCONFIG

env = 'multi-node-ubuntu14'
env = 'multi-node-centos7' if ENV['REPO_OS'].to_s.include?('centos')

# create controller-node with config defined above
machine 'controller' do
  add_machine_options vagrant_config: controller_config
  role 'multi-node-controller'
  chef_environment env
  file('/etc/chef/openstack_data_bag_secret',
       "#{File.dirname(__FILE__)}/../../../../../encrypted_data_bag_secret")
  converge true
end

[%w(compute1 61), %w(compute2 62)].each do |name, ip_suff|
  # config for compute-node vagrant box
  compute_config = <<-ENDCONFIG
  config.vm.provider "virtualbox" do |v|
    v.memory = 4048
    v.cpus = 2
    v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.vm.network "private_network", ip: "192.168.100.#{ip_suff}"
  config.vm.network "private_network", ip: "192.168.101.#{ip_suff}"
  ENDCONFIG

  # create compute-node with config defined above
  machine name do
    add_machine_options vagrant_config: compute_config
    role 'multi-node-compute'
    chef_environment env
    file('/etc/chef/openstack_data_bag_secret',
         "#{File.dirname(__FILE__)}/../../../../../encrypted_data_bag_secret")
    converge true
  end
end
