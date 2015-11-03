# All-in-One with nova-network

The defaults in the aio-nova.rb and the environments/vagrant-aio-nova.json should work without any changes.

Note: Default operating system is Ubuntu. If you would like CentOS, set env var REPO_OS=centos7

### Device interface

The device interface must be is specified by name in the aio-nova.rb file.
There is one place to change, look for `bridge: [....]`.  If your interface is not in the list, add it.
This is for an extra network adapter to your network, this is good practise for the
more advance setups.

+ For Windows 7, open the Control Panel, Network and Internet, Network Connections.  Look in the Connectivity column for a row with "Internet access", and use the "Device Name". For example, 'Intel(R) Centrino(R) Advanced-N 6205'.
+ For Mac, this works from some: `'en0: Wi-Fi (AirPort)'`, but there is an issue with VirtualBox and the Airport. You should look into using an Ethernet adaptor and something like: `'en3: Ethernet'`
+ For Linux, ...TODO...
