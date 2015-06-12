# Multi-node with nova-network

Note: Default operating system is Ubuntu. If you would like CentOS, set env var REPO_OS=centos7

## Nodes

The multi-node environments will have four machines `controller`, `compute1`, `compute2`, and `compute3`.

## Networking setup

Changes need to be made to the multi-nova.rb and the environments\vagrant-multi-nova.json or environments\vagrant-multi-centos7-nova.json file.

### Bridge IP Address

The IP address used for the bridge should on the same network as your machine connects to the internet. Change the '172.16.100.' ip address in the multi-nova.rb and the environments\vagrant-multi-nova.json files.
For example, on my home network, my laptop has an IP of 192.168.1.xxx, so I set the bridge address to 192.168.1.60.

### Device interface

The device interface must be is specified by name in the multi-nova.rb file.
There are two places to change, look for `<put your interface device name here>`.

+ For Windows 7, open the Control Panel, Network and Internet, Network Connections.  Look in the Connectivity column for a row with "Internet access", and use the "Device Name". For example, 'Intel(R) Centrino(R) Advanced-N 6205'.
+ For Mac, this works from some: 'en0: Wi-Fi (AirPort)'
+ For Linux, ...TODO...
