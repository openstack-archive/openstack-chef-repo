Description
===========
This repository will soon contain the documentation, roles, environments and data bags for deploying an OpenStack `Essex` reference architecture using Chef.

There will be a Spiceweasel (http://bit.ly/spcwsl) manifest documenting all the community cookbooks (and their versions), roles, data bags and environments required to deploy OpenStack. The intention is to only depend on publicly available community versions of cookbooks so the openstack-chef-repo will not contain any cookbooks (it is possible we will temporarily keep patched versions waiting for upstream to publish). The manifest will also document a variety of deployment techniques for single-node, small and large deployments.

This README.md will become a canonical source of documentation and there will be an additional `documentation` directory in the repository with more detailed instructions.

This Chef repository is intended for deploying stable releases and will initially only support `Essex`, but `Folsom` support will be worked on once `Essex` is fairly stable and supporting milestone releases becomes practical.

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
