Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-chef-zero"
Vagrant.require_plugin "vagrant-omnibus"

Vagrant.configure("2") do |config|
  # Berkshelf plugin configuration
  config.berkshelf.enabled = true

  # Chef-Zero plugin configuration
  config.chef_zero.enabled = true
  config.chef_zero.chef_repo_path = "."

  # Omnibus plugin configuration
  config.omnibus.chef_version = :latest

  # Port forwarding rules, for access to openstack services
  config.vm.network "forwarded_port", guest: 443, host: 8443     # dashboard-ssl
  config.vm.network "forwarded_port", guest: 8773, host: 8773    # compute-ec2-api
  config.vm.network "forwarded_port", guest: 8774, host: 8774    # compute-api

  # OpenStack-related settings
  config.vm.network "private_network", ip: "33.33.33.60"
  config.vm.network "private_network", ip: "192.168.100.60"
  config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--memory", 2048]
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
  end

  config.vm.provision :chef_client do |chef|
    chef.environment = "vagrant"
    chef.run_list = [ "recipe[apt::cacher-client]", "recipe[packages]", "role[allinone-compute]" ]
  end

  # Ubuntu 12.04 Config
  config.vm.define :ubuntu1204 do |ubuntu1204|
    ubuntu1204.vm.hostname = "ubuntu1204"
    ubuntu1204.vm.box = "opscode-ubuntu-12.04"
    ubuntu1204.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"
  end

  # Ubuntu 13.04 Config
  config.vm.define :ubuntu1304 do |ubuntu1304|
    ubuntu1304.vm.hostname = "ubuntu1304"
    ubuntu1304.vm.box = "opscode-ubuntu-13.04"
    ubuntu1304.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-13.04_provisionerless.box"
  end

end
