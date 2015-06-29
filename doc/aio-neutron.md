# All in One with Neutron

Note: Default operating system is Ubuntu. If you would like CentOS, set env var REPO_OS=centos7

## Networking setup

Changes need to be made to the multi-nova.rb and the environments\vagrant-multi-nova.json or environments\vagrant-multi-centos7-nova.json file.

### Bridge IP Address

Should be empty. With OVS which is what we support at the moment, OVS requires you not to have an IP associated with the NIC. If you do have DHCP enabled and the machine gains an IP you should delete it via something like: `sudo ip addr del 172.16.100.17/24 dev eth1` where `172.16.100.17` was the DHCP leased address.

### Device interface

The device interface must be is specified by name in the multi-neutron.rb file.
There one place to change, look for `<put your interface device name here>`, this is because of OVS and it needing to slurp up an adapter for internet access.

+ For Windows 7, open the Control Panel, Network and Internet, Network Connections.  Look in the Connectivity column for a row with "Internet access", and use the "Device Name". For example, 'Intel(R) Centrino(R) Advanced-N 6205'.
+ For Mac, this works from some: `'en0: Wi-Fi (AirPort)'`, but there is an issue with VirtualBox and the Airport. You should look into using an Ethernet adaptor and something like: `'en3: Ethernet'`
+ For Linux, ...TODO...
