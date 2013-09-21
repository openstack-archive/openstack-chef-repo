Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-cachier"
Vagrant.require_plugin "vagrant-chef-zero"
Vagrant.require_plugin "vagrant-omnibus"

Vagrant.configure("2") do |config|
  # Berkshelf plugin configuration
  config.berkshelf.enabled = true

  # Cachier plugin configuration
  config.cache.auto_detect = true

  # Chef-Zero plugin configuration
  config.chef_zero.enabled = true
  config.chef_zero.chef_repo_path = "."

  # Omnibus plugin configuration
  config.omnibus.chef_version = :latest

  # OpenStack-related settings
  config.vm.network "private_network", ip: "33.33.33.60"
  config.vm.network "private_network", ip: "192.168.100.60"
  config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--memory", 1024]
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
  end

  # Chef Zero doesn't do .rb files yet, so we expand out the allinone to the recipes
  roleallinone = [
    # "role[os-base]",
    "recipe[openstack-common]",
    "recipe[openstack-common::logging]",
    # "role[os-ops-database]",
    "recipe[openstack-ops-database::server]",
    "recipe[openstack-ops-database::openstack-db]",
    # "role[os-ops-messaging]",
    "recipe[openstack-ops-messaging::server]",
    # "role[os-identity]",
    "recipe[openstack-identity::server]",
    "recipe[openstack-identity::registration]",
    # "role[os-image]",
    "recipe[openstack-image::identity_registration]",
    "recipe[openstack-image::registry]",
    "recipe[openstack-image::api]",
    # "role[os-network]",
    "recipe[openstack-network::common]",
    # "role[os-compute-setup]",
    "recipe[openstack-compute::nova-setup]",
    "recipe[openstack-compute::identity-registration]",
    # "role[os-compute-conductor]",
    "recipe[openstack-compute::conductor]",
    # "role[os-compute-scheduler]",
    "recipe[openstack-compute::scheduler]",
    # "role[os-compute-api]",
    "recipe[openstack-compute::api-ec2]",
    "recipe[openstack-compute::api-os-compute]",
    "recipe[openstack-compute::api-metadata]",
    "recipe[openstack-compute::identity_registration]",
    # "role[os-block-storage]",
    "recipe[openstack-block-storage::api]",
    "recipe[openstack-block-storage::scheduler]",
    "recipe[openstack-block-storage::volume]",
    "recipe[openstack-block-storage::identity_registration]",
    # "role[os-compute-cert]",
    "recipe[openstack-compute::nova-cert]",
    # "role[os-compute-vncproxy]",
    "recipe[openstack-compute::vncproxy]",
    # "role[os-dashboard]",
    "recipe[openstack-dashboard::server]",
    # "role[os-compute-worker]"
    "recipe[openstack-compute::compute]"
  ]

  # Ubuntu 12.04 Config
  config.vm.define :ubuntu1204 do |ubuntu1204|
    ubuntu1204.vm.hostname = "ubuntu1204"
    ubuntu1204.vm.box = "opscode-ubuntu-12.04"
    ubuntu1204.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"
    ubuntu1204.vm.provision :chef_client do |chef|
      chef.environment = "vagrant"
      chef.run_list = [ "recipe[apt]", "recipe[packages]", roleallinone ]
    end
  end

  # Ubuntu 13.04 Config
  config.vm.define :ubuntu1304 do |ubuntu1304|
    ubuntu1304.vm.hostname = "ubuntu1304"
    ubuntu1304.vm.box = "opscode-ubuntu-13.04"
    ubuntu1304.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-13.04_provisionerless.box"
    ubuntu1304.vm.provision :chef_client do |chef|
      chef.environment = "vagrant"
      chef.run_list = [ "recipe[apt]", "recipe[packages]", roleallinone ]
    end
  end

end


