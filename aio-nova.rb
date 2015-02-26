require 'chef/provisioning'

controller_config = <<-ENDCONFIG
  config.vm.network "forwarded_port", guest: 443, host: 9443
  config.vm.network "forwarded_port", guest: 4002, host: 4002
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 6080, host: 6080
  config.vm.network "forwarded_port", guest: 8773, host: 8773
  config.vm.network "forwarded_port", guest: 8774, host: 8774
  config.vm.network "forwarded_port", guest: 35357, host: 35357
  config.vm.provider "virtualbox" do |v|
    v.memory = 8096
    v.cpus = 2
    v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.vm.network "private_network", ip: "192.168.100.60"
ENDCONFIG

machine 'controller' do
  add_machine_options vagrant_config: controller_config
  role 'allinone-compute'
  role 'os-image-upload'
  recipe 'openstack-common::openrc'
  # if you would like to use centos7 you'll need to
  # use 'vagrant-aio-centos7-nova' for the environment
  chef_environment 'vagrant-aio-nova'
  file('/etc/chef/openstack_data_bag_secret',
       "#{File.dirname(__FILE__)}/.chef/encrypted_data_bag_secret")
  converge true
end
