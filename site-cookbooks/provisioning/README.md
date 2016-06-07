# provisioning

This cookbook is used for serving chef-provisioning recipes for provisioning
OpenStack with Chef. It is intended to be referenced by chef-client in
local-mode a la ChefDK.

# recipes

## provisioning::vagrant_linux
* installs/uses a Vagrant box based on Linux distribution

## provisioning::allinone
* provisions an all-in-one OpenStack Compute Controller

## provisioning::multi-node
* provisions an OpenStack Controller with Compute nodes
