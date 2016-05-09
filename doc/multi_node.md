# Multi Node with Neutron

Note: Default operating system is Ubuntu. If you would like CentOS, set env var REPO_OS=centos7

## Networking setup

Changes need to be made to the multi-node.rb file.

## Node setup

The current multi_node rake task will create a three node OpenStack cluster
consisting of:

One controller-node hosting all the APIs (nova, neutron, cinder, glance,
keystone and heat) as well as a mysql database and a rabbitmq server. The
dasboard is run by default inside of an apache2 server. In addition to the APIs,
the controller also functions as the "network-node" and hosts the
neutron- (l3, dhcp and ovs) -agent to provide network connectivity (currently
only internal, and not to the outside world or the internet).

Two compute-nodes with the nova-compute service to run instances using qemu and
the neutron-ovs-agent for network connectivity to the contoller/network-node.

## TODO

* Currently no connectivity to the outside is supported out of the box. To do
  this, we need to bridge one of the interfaces of the controller/network node
  to the outside and utilise it as a public network.
* Add more detailed documentation
