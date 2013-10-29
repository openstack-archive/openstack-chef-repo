name "vagrant"
description "Environment used in testing with Vagrant the upstream cookbooks and reference Chef repository. Defines the network and database settings to use with OpenStack. The networks will be used in the libraries provided by the osops-utils cookbook. This example is for FlatDHCP with 2 physical networks."

override_attributes(
  "mysql" => {
    "allow_remote_root" => true,
    "root_network_acl" => "%"
  },
  "openstack" => {
    "developer_mode" => true,
    "identity" => {
      "catalog" => {
        "backend" => "templated"
      },
    },
    "image" => {
      "image_upload" => false,
      "upload_images" => ["cirros"],
      "upload_image" => {
        "cirros" => "https =>//launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img"
      },
      "identity_service_chef_role" => "allinone-compute"
    },
    "block-storage" => {
      "keystone_service_chef_role" => "allinone-compute"
    },
    "dashboard" => {
      "keystone_service_chef_role" => "allinone-compute"
    },
    "network" => {
      "rabbit_server_chef_role" => "allinone-compute"
    },
    "compute" => {
      "identity_service_chef_role" => "allinone-compute",
      "network" => {
        "fixed_range" => "192.168.100.0/24",
        "public_interface" => "eth2"
      },
      "config" => {
        "ram_allocation_ratio" => 5.0
      },
      "libvirt" => {
        "virt_type" => "qemu"
      },
      "networks" => [
        {
          "label" => "public",
          "ipv4_cidr" => "192.168.100.0/24",
          "num_networks" => "1",
          "network_size" => "255",
          "bridge" => "br100",
          "bridge_dev" => "eth2",
          "dns1" => "8.8.8.8",
          "dns2" => "8.8.4.4"
        }
      ]
    }
  }
)
