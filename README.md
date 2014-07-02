# Description #

This repository contains examples of the roles, environments and other supporting files for deploying an OpenStack **Icehouse** reference architecture using Chef. This currently includes all OpenStack core projects: Compute, Dashboard, Identity, Image, Network, Object Storage, Block Storage, Telemetry and Orchestration.

Development of the latest Stable release will continue on the `master` branch and releases tagged with `9.0.X`. Once development starts against OpenStack `master` or `juno`, this branch will move to `stable/icehouse` and the appropriate branches will continue development.

The documentation has been moved to the https://github.com/mattray/chef-docs repository for merging to https://github.com/opscode/chef-docs and eventual release to https://docs.opscode.com. Instructions for building the docs are included in the repository. There is additional documentation on the [OpenStack wiki](https://wiki.openstack.org/wiki/Chef/GettingStarted).

# Usage #

This repository uses Berkshelf (https://berkshelf.com) to manage downloading all of the proper cookbook versions, whether from Git or from the Opscode Community site (https://community.opscode.com). The preference is to eventually upstream all cookbook dependencies to the Opscode Community site. The [Berksfile](Berksfile) lists the current dependencies. Note that berks will resolve version requirements and dependencies on first run and store these in Berksfile.lock. If new cookbooks become available you can run `berks update` to update the references in Berksfile.lock. Berksfile.lock will be included in stable branches to provide a known good set of dependencies. Berksfile.lock will not be included in development branches to encourage development against the latest cookbooks.

There is a Spiceweasel (http://bit.ly/spcwsl) [infrastructure.yml](infrastructure.yml) manifest documenting all the roles and environments required to deploy OpenStack.

To see the commands necessary to push all of the files to the Chef server, run the following command:

```
spiceweasel infrastructure.yml
```

To actually deploy the repository to your Chef server, run the following command:

```
spiceweasel -e infrastructure.yml
```
# Databags #

You need to have some databags when you run the stackforge without the developer_mode -> true.

You need four databags : user_passwords, db_passwords, service_passwords, secrets

Each data bag need the following item to be created.

user_passwords
  ITEM example :    {"id" : "admin", "admin" : "mypass"}
    - admin
    - guest

db_passwords
  ITEM example :    {"id" : "nova", "nova" : "mypass"}

    - nova
    - horizon
    - keystone
    - glance
    - ceilometer
    - neutron
    - cinder
    - heat
    - dash

service_passwords
  ITEM example :    {"id" : "openstack-image", "openstack-image" : "mypass"}

    - openstack-image
    - openstack-compute
    - openstack-block-storage
    - openstack-orchestration
    - openstack-network
    - rbd

secrets
  ITEM example : {"id" : "openstack_identity_bootstrap_token", "openstack_identity_bootstrap_token" : "mytoken"}

    - openstack_identity_bootstrap_token
    - neutron_metadata_secret

# Cookbooks #

The cookbooks have been designed and written in such a way that they can be used to deploy individual service components on _any_ of the nodes in the infrastructure; in short they can be used for single node 'all-in-one' installs (for testing), right up to multi/many node production installs. In order to achieve this flexibility, they are configured by attributes which may be used to override search. Chef 11 or later is currently required. Ruby 1.9.x is considered the minimum supported version of Ruby as well. Most users of this repository test with the full-stack Chef 11 client and a Chef server (Chef Solo is not explicity supported).

Each of the OpenStack services has its own cookbook and will eventually be available on the Chef Community site.

## OpenStack Block Storage ##

http://github.com/stackforge/cookbook-openstack-block-storage/

There is further documentation in the [OpenStack Block Storage cookbook README](http://github.com/stackforge/cookbook-openstack-block-storage/).

## OpenStack Compute ##

http://github.com/stackforge/cookbook-openstack-compute/

There is further documentation in the [OpenStack Compute cookbook README](http://github.com/stackforge/cookbook-openstack-compute/).

## OpenStack Dashboard ##

http://github.com/stackforge/cookbook-openstack-dashboard/

There is further documentation in the [OpenStack Dashboard cookbook README](http://github.com/stackforge/cookbook-openstack-dashboard/).

## OpenStack Identity ##

http://github.com/stackforge/cookbook-openstack-identity/

There is further documentation in the [OpenStack Identity cookbook README](http://github.com/stackforge/cookbook-openstack-identity/).

## OpenStack Image ##

http://github.com/stackforge/cookbook-openstack-image/

There is further documentation in the [OpenStack Image cookbook README](http://github.com/stackforge/cookbook-openstack-image/).

## OpenStack Network ##

Http://github.com/stackforge/cookbook-openstack-network/

There is further documentation in the [OpenStack Network cookbook README](http://github.com/stackforge/cookbook-openstack-network/).

## OpenStack Object Storage ##

http://github.com/stackforge/cookbook-openstack-object-storage/

There is further documentation in the [OpenStack Object Storage cookbook README](http://github.com/stackforge/cookbook-openstack-object-storage/).

## Galera ##

http://community.opscode.com/cookbooks/galera

There is further documentation in the [Galera cookbook README](http://community.opscode.com/cookbooks/galera/source).

Data bag:

s9s_galera / config.json
-------------------------
        {
          "id": "config",
          "mysql_wsrep_tarball_x86_64": "mysql-5.5.29_wsrep_23.7.3-linux-x86_64.tar.gz",
          "mysql_wsrep_tarball_i686": "mysql-5.5.29_wsrep_23.7.3-linux-i686.tar.gz",
          "galera_package_i386": {
            "deb": "galera-23.2.4-i386.deb",
            "rpm": "galera-23.2.4-1.rhel5.i386.rpm"},
          "galera_package_x86_64": {
            "deb": "galera-23.2.4-amd64.deb",
            "rpm": "galera-23.2.4-1.rhel5.x86_64.rpm"
          },
          "mysql_wsrep_source": "https://launchpad.net/codership-mysql/5.5/5.5.29-23.7.3/+download",
          "galera_source": "https://launchpad.net/galera/2.x/23.2.4/+download",
          "sst_method": "rsync",
          "init_node": "192.168.122.12",
          "galera_nodes": [
             "192.168.122.12",
             "192.168.122.14",
             "192.168.122.16"
            ],
           "secure": "yes",
           "update_wsrep_urls": "yes"
        }
        
Attrbitues:
* ['mysql']['root_password'] = "password"
* ['mysql']['tunable']['buffer_pool_size'] = "256M"

# Testing #

Please refer to the [TESTING.md](TESTING.md) for instructions for testing the repository and cookbooks with Vagrant or Vagabond.

# License and Author #

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author**           | Matt Ray (<matt@opscode.com>)            |
| **Author**           | Jay Pipes (<jaypipes@gmail.com>)         |
| **Author**           | Chen Zhiwei (<zhiwchen@cn.ibm.com>)      |
| **Author**           | Mark Vanderwiel (<vanderwl.us.ibm.com>)  |
|                      |                                          |
| **Copyright**        | Copyright (c) 2011-2013 Opscode, Inc.    |
| **Copyright**        | Copyright (c) 2014 IBM, Corp.            |

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
