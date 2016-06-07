require 'chef/provisioning'

default_bridge = '["en0: USB Ethernet","en1: USB Ethernet",'
default_bridge += '"en2: USB Ethernet","en3: USB Ethernet",'
default_bridge += '"en4: USB Ethernet","eth0","wlan0",'
default_bridge += '"en0: Wi-Fi (AirPort)","en1: Wi-Fi (AirPort)",'
default_bridge += '"en2: Wi-Fi (AirPort)",'
default_bridge += '"Intel(R) Centrino(R) Advanced-N 6205"]'

if ENV['OS_BRIDGE']
  bridge = "\"#{ENV['OS_BRIDGE']}\""
else
  bridge = default_bridge
end

controller_config = <<-ENDCONFIG
  config.vm.network "forwarded_port", guest: 443, host: 9443
  config.vm.network "forwarded_port", guest: 4002, host: 4002
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 6080, host: 6080
  config.vm.network "forwarded_port", guest: 8773, host: 8773
  config.vm.network "forwarded_port", guest: 8774, host: 8774
  config.vm.network "forwarded_port", guest: 35357, host: 35357
  config.vm.provider "virtualbox" do |v|
    v.memory = 8192
    v.cpus = 4
    v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.vm.network "public_network",
    bridge: #{bridge}
ENDCONFIG

env = 'allinone-ubuntu14'
env = 'allinone-centos7' if ENV['REPO_OS'].to_s.include?('centos')

machine 'controller' do
  add_machine_options vagrant_config: controller_config
  role 'allinone'
  chef_environment env
  file('/etc/chef/openstack_data_bag_secret',
       "#{File.dirname(__FILE__)}/../../../../../encrypted_data_bag_secret")
  converge true
end
