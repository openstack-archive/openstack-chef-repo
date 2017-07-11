require 'chef/provisioning'
require 'chef/provisioning/vagrant_driver'

with_driver 'vagrant'

os = 'ubuntu/xenial64'
os = 'centos/7' if ENV['REPO_OS'].to_s.include?('centos')

env = 'allinone-ubuntu16'
env = 'allinone-centos7' if ENV['REPO_OS'].to_s.include?('centos')

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
# allinone compute controller
###
options = {
  vagrant_options: {
    'vm.box' => os,
    'vm.network' => [
      ':forwarded_port, guest: 443, host: 9443',
      ':forwarded_port, guest: 4002, host: 4002',
      ':forwarded_port, guest: 5000, host: 5000',
      ':forwarded_port, guest: 6080, host: 6080',
      ':forwarded_port, guest: 8773, host: 8773',
      ':forwarded_port, guest: 8774, host: 8774',
      ':forwarded_port, guest: 35357, host: 35357'
    ]
  },
  vagrant_config: <<-EOF
    config.vm.provision "chef_solo" do |chef|
      chef.version = "12.21.3"
      chef.channel = "stable"
    end
    config.vm.provider "virtualbox" do |v|
      v.memory = 8192
      v.cpus = 4
      v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
    config.vm.define "controller" do |cont|
      cont.vm.network "private_network", :type => "dhcp", :adapter => 2
      cont.vm.network "public_network", :dev => "#{bridge}", :mode => "bridge", :type => "bridge"
    end
  EOF
}

machine 'controller' do
  machine_options options
  role 'allinone'
  chef_environment env
  file('/etc/chef/openstack_data_bag_secret',
       "#{File.dirname(__FILE__)}/../../../../../encrypted_data_bag_secret")
  converge true
end
