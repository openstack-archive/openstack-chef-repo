# Description #

This repository contains examples of the roles, environments and other supporting files for deploying an OpenStack **Grizzly** reference architecture using Chef. This currently includes the 7 OpenStack core projects: Compute, Dashboard, Identity, Image, Network, Object and Block Storage.

Development of the latest Stable release will continue on the `master` branch and releases tagged with `7.0.X`. Once development starts against OpenStack `master` or `havana`, this branch will move to `grizzly` and the appropriate branches will continue development.

The documentation has been moved to the https://github.com/mattray/chef-docs repository for merging to https://github.com/opscode/chef-docs and eventual release to https://docs.opscode.com. Instructions for building the docs are included in the repository. There is additional documentation on the [OpenStack wiki](https://wiki.openstack.org/wiki/Chef/GettingStarted).

# Usage #

This repository uses Berkshelf (https://berkshelf.com) to manage downloading all of the proper cookbook versions, whether from Git or from the Opscode Community site (https://community.opscode.com). The preference is to eventually upstream all cookbook dependencies to the Opscode Community site. The [Berksfile](Berksfile) lists the current dependencies.

There is a Spiceweasel (http://bit.ly/spcwsl) [infrastructure.yml](infrastructure.yml) manifest documenting all the roles and environments required to deploy OpenStack.

To see the commands necessary to push all of the files to the Chef server, run the following command:

```
spiceweasel infrastructure.yml
```

To actually deploy the repository to your Chef server, run the following command:

```
spiceweasel -e infrastructure.yml
```

# Cookbooks #

The cookbooks have been designed and written in such a way that they can be used to deploy individual service components on _any_ of the nodes in the infrastructure; in short they can be used for single node 'all-in-one' installs (for testing), right up to multi/many node production installs. In order to achieve this flexibility, they are configured by attributes which may be used to override search. Chef 10 or later is currently required, but the intention is to [move to Chef 11 with the `havana` release](https://bugs.launchpad.net/openstack-chef/+bug/1183540) to take advantage of features such as [partial search](http://docs.opscode.com/essentials_search_partial.html). Ruby 1.9.x is considered the minimum supported version of Ruby as well. Most users of this repository test with the full-stack Chef 11 client and a Chef server (Chef Solo is not explicity supported).

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

## Testing

We use Vagabond to do integration testing. The Vagabondfile in the root
directory of the Chef repo contains the definitions of the nodes that
are used during integration testing.

To set up Vagabond, do this:

    bundle exec vagabond init

When prompted, answer "N" to not overwrite the existing Vagabondfile, and then
answer "n" for all templates you don't want to use and "y" for the rest.

When running integration tests, Vagabond starts up a set of LXC containers
to represent the actual hardware nodes used in a deployment, including the
Chef server itself. The nodes we use in integration testing are the
following:

* `server` -- A hardcoded LXC instance name that contains a Chef 11 server
              that is loaded up with the Berkshelf cookbooks, the role definitions,
              and environment definitions defined in this Chef repo
* `ops` -- An LXC instance that gets all the ops-related recipes and applications
           installed in it, including databases, message queues, logging, etc
* `compute-worker` -- An LXC instance that acts as a compute worker
* `controller` -- An LXC instance that contains all the OpenStack control software

### Vagabond Local Chef Server

To start the local Chef 11 server LXC instance using Vagabond:

    bundle exec vagabond server up

The above will automatically upload the roles and environment
definitions in this Chef repo along with all of the cookbooks
in the Berkshelf.

To re-upload all of the cookbooks in the Berkshelf, simply do:

    bundle exec vagabond server upload_cookbooks

To re-upload the roles or environment files:

    bundle exec vagabond server upload_roles
    bundle exec vagabond server upload_environments

Remember that the above will install the **current** Berkshelf. Remember to
run:

    bundle exec berks update

before you do the `vagabond server upload_cookbooks` command.

### Test Nodes

To start any of the LXC instances that represent the different ops, controller
and worker nodes in an OpenStack environment, do:

    bundle exec vagabond up <NODE>

If you make changes to cookbooks and issue a `vagabond server upload_cookbooks` or
role/environment definitions, you will want to re-provision the node, which basically
ensures the node is up and runs chef-client on it:

    bundle exec vagabond provision <NODE>

To destroy a node:

    bundle exec vagabond destroy <NODE>

To entirely rebuild a node from scratch:

    bundle exec vagabond rebuild <NODE>

When a node is up, you can SSH into that node to run tests or investigate logs, etc:

    bundle exec vagabond ssh <NODE>

To see the status of all the nodes that Vagabond is managing, including the IP addresses
that the containers are bound to:

    bundle exec vagabond status

# License and Author #

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author**           | Matt Ray (<matt@opscode.com>)            |
| **Author**           | Jay Pipes (<jaypipes@gmail.com>)         |
|                      |                                          |
| **Copyright**        | Copyright (c) 2011-2013 Opscode, Inc.    |

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
