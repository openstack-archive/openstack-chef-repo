name "testing"
description "Environment used in testing the upstream cookbooks and reference Chef repository"

override_attributes(
  "mysql" => {
    "server_root_password" => "root",
    "server_debian_password" => "root",
    "server_repl_password" => "root",
    "allow_remote_root" => true,
    "root_network_acl" => "%"
  },
  "openstack" => {
    "auth" => {
      "validate_certs" => false
    },
    "block-storage" => {
      "syslog" => {
        "use" => false
      },
      "api" => {
        "ratelimit" => "False"
      },
      "debug" => true,
      "image_api_chef_role" => "os-image",
      "identity_service_chef_role" => "os-identity",
      "rabbit_server_chef_role" => "os-ops-messaging"
    },
    "compute" => {
      "syslog" => {
        "use" => false
      },
      "libvirt" => {
        "bind_interface" => "eth0"
      },
      "novnc_proxy" => {
        "bind_interface" => "eth0"
      },
      "xvpvnc_proxy" => {
        "bind_interface" => "eth0"
      },
      "image_api_chef_role" => "os-image",
      "identity_service_chef_role" => "os-identity",
      "nova_setup_chef_role" => "os-compute-api",
      "rabbit_server_chef_role" => "os-ops-messaging",
      "ratelimit" => {  # Disable ratelimiting so Tempest doesn't have issues.
        "api" => {
          "enabled" => false
        },
        "volume" => {
          "enabled" => false
        }
      },
      "network" => {
        "fixed_range" => "10.0.0.0/8"
      },
      "networks" => [
      ]
    },
    "db" => {
      "bind_interface" => "eth0",
      "compute" => {
        "host" => "10.0.3.10"
      },
      "identity" => {
        "host" => "10.0.3.10"
      },
      "image" => {
        "host" => "10.0.3.10"
      },
      "network" => {
        "host" => "10.0.3.10"
      },
      "volume" => {
        "host" => "10.0.3.10"
      },
      "dashboard" => {
        "host" => "10.0.3.10"
      },
      "metering" => {
        "host" => "10.0.3.10"
      }
    },
    "developer_mode" => true,
    "endpoints" => {
      "compute-api" => {
        "host" => "10.0.3.11",
        "scheme" => "http",
        "port" => "8774",
        "path" => "/v2/%(tenant_id)s"
      },
      "compute-ec2-admin" => {
        "host" => "10.0.3.11",
        "scheme" => "http",
        "port" => "8773",
        "path" => "/services/Admin"
      },
      "compute-ec2-api" => {
        "host" => "10.0.3.11",
        "scheme" => "http",
        "port" => "8773",
        "path" => "/services/Cloud"
      },
      "compute-xvpvnc" => {
        "host" => "10.0.3.11",
        "scheme" => "http",
        "port" => "6081",
        "path" => "/console"
      },
      "compute-novnc" => {
        "host" => "10.0.3.11",
        "scheme" => "http",
        "port" => "6080",
        "path" => "/vnc_auto.html"
      },
      "image-api" => {
        "host" => "10.0.3.11",
        "scheme" => "http",
        "port" => "9292",
        "path" => "/v2"
      },
      "image-registry" => {
        "host" => "10.0.3.11",
        "scheme" => "http",
        "port" => "9191",
        "path" => "/v2"
      },
      "identity-api" => {
        "host" => "10.0.3.11",
        "scheme" => "http",
        "port" => "5000",
        "path" => "/v2.0"
      },
      "identity-admin" => {
        "host" => "10.0.3.11",
        "scheme" => "http",
        "port" => "35357",
        "path" => "/v2.0"
      },
      "volume-api" => {
        "host" => "10.0.3.11",
        "scheme" => "http",
        "port" => "8776",
        "path" => "/v1/%(tenant_id)s"
      },
      "metering-api" => {
        "host" => "10.0.3.11",
        "scheme" => "http",
        "port" => "8777",
        "path" => "/v1"
      },
      "network-api" => {
        "host" => "10.0.3.11",
        "scheme" => "http",
        "port" => "9696",
        "path" => "/v2"
      }
    },
    "identity" => {
      "admin_user" => "ksadmin",
      "bind_interface" => "eth0",
      "catalog" => {
        "backend" => "templated"
      },
      "debug" => true,
      "rabbit_server_chef_role" => "os-ops-messaging",
      "roles" => [
        "admin",
        "keystone_admin",
        "keystone_service_admin",
        "member",
        "netadmin",
        "sysadmin"
      ],
      "syslog" => {
        "use" => false
      },
      "tenants" => [
        "admin",
        "service",
        "demo"
      ],
      "token" => {
        "backend" => "memcache"
      },
      "users" => {
        "ksadmin" => {
          "password" => "ksadmin",
          "default_tenant" => "admin",
          "roles" => { # Each key is the role name, each value is a list of tenants
            "admin" => [
              "admin"
            ],
            "keystone_admin" => [
              "admin"
            ],
            "keystone_service_admin" => [
              "admin"
            ]
          }
        },
        "demo" => {
          "password" => "demo",
          "default_tenant" => "demo",
          "roles" => { # Each key is the role name, each value is a list of tenants
            "sysadmin" => [
              "demo"
            ],
            "netadmin" => [
              "demo"
            ],
            "member" => [
              "demo"
            ]
          }
        }
      }
    },
    "image" => {
      "api" => {
        "bind_interface" => "eth0"
      },
      "debug" => true,
      "identity_service_chef_role" => "os-identity",
      "image_upload" => true,
      "rabbit_server_chef_role" => "os-ops-messaging",
      "registry" => {
        "bind_interface" => "eth0"
      },
      "syslog" => {
        "use" => false
      },
      "upload_image" => {
        "cirros" => "http://hypnotoad/cirros-0.3.0-x86_64-disk.img",
      },
      "upload_images" => [
        "cirros"
      ]
    },
    "memcached_servers" => [
      "10.0.3.10:11211"
    ],
    "mq" => {
      "bind_interface" => "eth0",
      "host" => "10.0.3.10",
      "user" => "guest",
      "vhost" => "/nova"
    }
  },
  "queue" => {
    "host" => "10.0.3.10",
    "user" => "guest",
    "vhost" => "/nova"
  }
)
