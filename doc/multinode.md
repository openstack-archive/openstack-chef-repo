# Multinode With Neutron

Note: Default operating system is Ubuntu. CentOS is also supported.

## Node setup

The current multinode rake task will create a four node OpenStack cluster
consisting of:

One controller node hosting all the APIs (Nova, Neutron, Cinder, Glance,
Keystone and Heat) as well as a MySQL database and a RabbitMQ server. The
dashboard is run by default inside of an apache2 server.

The "network node" hosts the neutron agents (L3, DHCP, OVS) to provide network
connectivity internally and to the outside world. It provides this connectivity
by bridging to an interface running on the host machine.

Two compute nodes with the nova-compute service to run instances using qemu and
the neutron-ovs-agent for network connectivity to the controller/network node.

## TODO

* Add more detailed documentation
