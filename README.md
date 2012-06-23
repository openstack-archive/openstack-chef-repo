Description
===========
This repository contains documentation, roles, environments and data bags for deploying an OpenStack **Essex** reference architecture using Chef. This currently includes the 5 OpenStack core projects: Nova, Glance, Keystone, Swift and Horizon.

Please use this `essex` branch to get the latest stable release. The `master` branch will remain empty until work begins on the **Folsom** pre-release. After **Folsom** is branched in OpenStack, it will get its own `folsom` Git branch as well.

This is a canonical source of documentation and there is additional content in the `documentation` directory in this repository.

There is a Spiceweasel (http://bit.ly/spcwsl) manifest documenting all the community cookbooks (and their versions), roles, data bags and environments required to deploy OpenStack. The intention is to only depend on publicly available community versions of cookbooks so the openstack-chef-repo will not contain any cookbooks (there may temporarily be patched versions waiting for upstream to publish). The manifest will also document a variety of deployment techniques for single-node, small and large deployments.

Cookbooks
=========
The cookbooks have been designed and written in such a way that they can be used to deploy individual service components on _any_ of the nodes in the infrastructure; in short they can be used for single node 'all-in-one' installs (for testing), right up to multi/many node production installs. In order to achieve this flexibility, they make use of the [chef search](http://wiki.opscode.com/display/chef/Search) functionality, and therefore require that if you are deploying anything larger than a single node deployment, you use [chef server](http://wiki.opscode.com/display/chef/Chef+Server) to host your cookbooks rather than using Chef Solo.

Each of the OpenStack services has its own cookbook and is available on the Chef Community site and on GitHub. Please refer to the `documentation` directory for more details on each.

Nova
----
http://community.opscode.com/cookbooks/nova

http://github.com/mattray/nova

Glance
------
http://community.opscode.com/cookbooks/glance

http://github.com/mattray/glance

Keystone
--------
http://community.opscode.com/cookbooks/keystone

http://github.com/mattray/keystone

Horizon
--------
http://community.opscode.com/cookbooks/horizon

http://github.com/mattray/horizon

Swift
-----
http://community.opscode.com/cookbooks/swift

http://github.com/mattray/swift

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
