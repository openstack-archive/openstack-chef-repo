require 'chef/provisioning'
require 'chef/provisioning/vagrant_driver'

with_driver 'vagrant'

os = 'ubuntu/xenial64'
os = 'centos/7' if ENV['REPO_OS'].to_s.include?('centos')

env = 'multinode-ubuntu16'
env = 'multinode-centos7' if ENV['REPO_OS'].to_s.include?('centos')

# make sure your ethernet interface matches preferred_interfaces, or override
# with OS_BRIDGE

# rubocop:disable LineLength
preferred_interfaces = ['Ethernet', 'eth0', 'enp3s0', 'Wi-Fi',
                        'Thunderbolt 1', 'Thunderbolt 2', 'Centrino']
host_interfaces = `VBoxManage list bridgedifs | grep ^Name`
                  .gsub(/Name:\s+/, '').split("\n")
default_bridge = preferred_interfaces.map { |pi| host_interfaces.find { |vm| vm =~ /#{Regexp.quote(pi)}/ } }.compact[0]
# rubocop:enable LineLength

bridge = if ENV['OS_BRIDGE']
           "\"#{ENV['OS_BRIDGE']}\""
         else
           default_bridge
         end

###
# compute controller
###

controller_options = {
  vagrant_options: {
    'vm.box' => os,
    'vm.network' => [
      ':private_network, {ip: "192.168.100.60"}',
      ':private_network, {ip: "192.168.101.60"}',
      ':forwarded_port, guest: 443, host: 9443',
      ':forwarded_port, guest: 4002, host: 4002',
      ':forwarded_port, guest: 5000, host: 5000',
      ':forwarded_port, guest: 6080, host: 6080',
      ':forwarded_port, guest: 8773, host: 8773',
      ':forwarded_port, guest: 8774, host: 8774',
      ':forwarded_port, guest: 35357, host: 35357'
    ]
  },
  vagrant_config: <<-EOH
    config.vm.provision "chef_solo" do |chef|
      chef.version = "12.21.3"
      chef.channel = "stable"
    end
    config.vm.provider "virtualbox" do |v|
      v.memory = 6144
      v.cpus = 2
      v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  EOH
}

# create controller node with the config defined above
machine 'controller' do
  machine_options controller_options
  role 'multinode-controller'
  chef_environment env
  file('/etc/chef/openstack_data_bag_secret',
       "#{File.dirname(__FILE__)}/../../../../../encrypted_data_bag_secret")
  converge true
end

###
# network controller config
###

network_options = {
  vagrant_options: {
    'vm.box' => os,
    'vm.network' => [
      ':private_network, {ip: "192.168.100.70"}',
      ':private_network, {ip: "192.168.101.70"}'
    ]
  },
  vagrant_config: <<-EOH
    config.vm.provision "chef_solo" do |chef|
      chef.version = "12.21.3"
      chef.channel = "stable"
    end
    config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
      v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
      v.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
    config.vm.define "network" do |net|
      net.vm.network "public_network", :dev => "#{bridge}", :mode => "bridge", :type => "bridge"
    end
  EOH
}

# create network node with the config defined above
machine 'network' do
  machine_options network_options
  role 'multinode-network'
  chef_environment env
  file('/etc/chef/openstack_data_bag_secret',
       "#{File.dirname(__FILE__)}/../../../../../encrypted_data_bag_secret")
  converge true
end

machine_batch do
  compute_nodes = 2
  compute_nodes.times do |number|
    compute_options = {
      vagrant_options: {
        'vm.box' => os,
        'vm.network' => [
          ":private_network, {ip: '192.168.100.#{61 + number}'}",
          ":private_network, {ip: '192.168.101.#{62 + number}'}"
        ]
      },
      vagrant_config: <<-EOH
        config.vm.provision "chef_solo" do |chef|
          chef.version = "12.21.3"
          chef.channel = "stable"
        end
        config.vm.provider "virtualbox" do |v|
          v.memory = 1024
          v.cpus = 2
          v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
          v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
          v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        end
      EOH
    }
    # create compute nodes with the config defined above
    machine "compute#{number + 1}" do
      machine_options compute_options
      role 'multinode-compute'
      chef_environment env
      file('/etc/chef/openstack_data_bag_secret',
           "#{File.dirname(__FILE__)}/../../../../../encrypted_data_bag_secret")
      converge true
    end
  end
end
