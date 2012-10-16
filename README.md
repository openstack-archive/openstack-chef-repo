Description
===========
This repository contains the roles, environments and data bags for deploying an OpenStack **Essex** reference architecture using Chef. This currently includes the 5 OpenStack core projects: Nova, Glance, Keystone, Horizon and Swift(under development). Folsom development will begin very soon.

Please use this `essex` branch to get the latest stable release. Once **Folsom** work is started, the `essex` branch will be merged back to the `master` branch and that will become active again.

The documentation has been moved to the https://github.com/mattray/openstack-chef-docs repository. A public URL will be available soon, but instructions for building the docs are included and you can visit a temporary site here:
http://15.185.230.54/

This repository uses Librarian (https://github.com/applicationsonline/librarian) to manage downloading all of the proper cookbook versions, whether from Git or from the Opscode Community site (https://community.opscode.com). The preference is to eventually publish all of the cookbook dependencies to the Opscode Community site.

There is also a Spiceweasel (http://bit.ly/spcwsl) manifest documenting all the community cookbooks (currently redundant with Librarian), roles, data bags and environments required to deploy OpenStack.

Usage
=====
To populate this Chef repository with the cookbooks for deploying, run the following command:

```
librarian-chef update
```

To see the commands necessary to push all of the files to the Chef server, run the following command:

```
spiceweasel infrastructure.yml
```

To actually deploy the repository to your Chef server, run the following command:

```
spiceweasel infrastructure.yml | sh
```

Cookbooks
=========
The cookbooks have been designed and written in such a way that they can be used to deploy individual service components on _any_ of the nodes in the infrastructure; in short they can be used for single node 'all-in-one' installs (for testing), right up to multi/many node production installs. In order to achieve this flexibility, they make use of the [chef search](http://wiki.opscode.com/display/chef/Search) functionality, and therefore require that if you are deploying anything larger than a single node deployment, you use [chef server](http://wiki.opscode.com/display/chef/Chef+Server) to host your cookbooks rather than using Chef Solo. It is important to note that much of the search is driven by the roles wrapping the recipes, so use the roles to deploy rather than directly including recipes in your run lists.

Each of the OpenStack services has its own cookbook and is available on the Chef Community site and on GitHub. Please refer to the `documentation` directory for more details on the roles for deploying them.

Glance
------
http://community.opscode.com/cookbooks/glance

http://github.com/mattray/glance

There is further documentation in the [Glance cookbook README.me](http://github.com/mattray/glance/blob/essex/README.md).

Horizon
--------
http://community.opscode.com/cookbooks/horizon

http://github.com/mattray/horizon

There is further documentation in the [Horizon cookbook README.me](http://github.com/mattray/horizon/blob/essex/README.md).

Keystone
--------
http://community.opscode.com/cookbooks/keystone

http://github.com/mattray/keystone

There is further documentation in the [Keystone cookbook README.me](http://github.com/mattray/keystone/blob/essex/README.md).

Nova
----
http://community.opscode.com/cookbooks/nova

http://github.com/mattray/nova

There is further documentation in the [Nova cookbook README.me](http://github.com/mattray/nova/blob/essex/README.md).

Swift
-----
http://community.opscode.com/cookbooks/swift

http://github.com/mattray/swift

There is further documentation in the [Swift cookbook README.me](http://github.com/mattray/swift/blob/essex/README.md).

License
=======
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
