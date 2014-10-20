# Description #

This repository contains examples of the roles, environments and other supporting files for deploying an OpenStack **Juno** reference architecture using Chef. This currently includes all OpenStack core projects: Compute, Dashboard, Identity, Image, Network, Object Storage, Block Storage, Telemetry and Orchestration.

Development of the latest OpenStack release will continue on the `master` branch and releases tagged with `10.0.X`. Once development starts against OpenStack `k` release, this branch will move to `stable/juno` and the appropriate branches will continue development.

The documentation has been moved to the https://github.com/mattray/chef-docs repository for merging to https://github.com/opscode/chef-docs and eventual release to https://docs.opscode.com. Instructions for building the docs are included in the repository. There is additional documentation on the [OpenStack wiki](https://wiki.openstack.org/wiki/Chef/GettingStarted).

# Usage with Chef Server #

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

# Usage with Chef Zero #

[Chef Zero](http://www.getchef.com/blog/2013/10/31/chef-client-z-from-zero-to-chef-in-8-5-seconds/) is Chef local mode, without Chef server.

## Install Chef

```
curl -L https://www.opscode.com/chef/install.sh | bash
```

## Checkout cookbooks

```
git clone https://github.com/stackforge/openstack-chef-repo
cd openstack-chef-repo
/opt/chef/embedded/bin/gem install berkshelf
/opt/chef/embedded/bin/berks vendor ./cookbooks
```

## Prepare Chef environment

Here is a minimal [environment file](environments/zero-demo.json).

```
{
  "name": "zero-demo",
  "override_attributes": {
    "mysql": {
      "server_root_password": "ilikerandompasswords"
    },
    "openstack": {
      "developer_mode": true
    }
  }
}
```

## Start to deploy

Note that `your_node_name` below is your node's hostname.

```
cd openstack-chef-repo
chef-client -z
knife node -z add run_list your_node_name 'role[allinone-compute]'
chef-client -z -E zero-demo
```

If there are no errors in output, congratulations!

# Databags #

You need to have some databags when you run the stackforge without the developer_mode -> true.

You need four databags : user_passwords, db_passwords, service_passwords, secrets

Each data bag need the following item to be created.

user_passwords
  ITEM example :    {"id" : "admin", "admin" : "mypass"}
    - admin
    - guest

```bash
for item in admin guest ; do
 knife data bag create user_passw $p --secret-file ~/.chef/openstack_data_bag_secret;
done
```

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

```bash
for item in nova horizon keystone glance ceilmeter neutron cinder heat dash ; do
 knife data bag create db_passwords $p --secret-file ~/.chef/openstack_data_bag_secret;
done
```

service_passwords
  ITEM example :    {"id" : "openstack-image", "openstack-image" : "mypass"}

    - openstack-image
    - openstack-compute
    - openstack-block-storage
    - openstack-orchestration
    - openstack-network
    - rbd

```bash
for item in openstack-image openstack-compute openstack-block-storage openstack-orchestration openstack-network rbd ; do
 knife data bag create service_passwords $p --secret-file ~/.chef/openstack_data_bag_secret;
done
```

secrets
  ITEM example : {"id" : "openstack_identity_bootstrap_token", "openstack_identity_bootstrap_token" : "mytoken"}

    - openstack_identity_bootstrap_token
    - neutron_metadata_secret

```bash
for item in openstack_identity_bootstrap_token neutron_metadata_secret ; do
 knife data bag create secrets $p --secret-file ~/.chef/openstack_data_bag_secret;
done
```

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
