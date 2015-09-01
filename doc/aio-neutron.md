# All in One with Neutron

Note: Default operating system is Ubuntu. If you would like CentOS, set env var REPO_OS=centos7

## Networking setup

Changes need to be made to the aio-neutron.rb file.

### Device interface

The device interface must be is specified by name in the aio-neutron.rb file.
There is one place to change, look for `<put your interface device name here>`,
this is because of OVS needing to slurp up an adapter for internet access.

Note: To see a list of virtualbox network interface names use:
    `$ vboxmanage list bridgedifs`

+ For Windows 7, open the Control Panel, Network and Internet, Network Connections.  Look in the Connectivity column for a row with "Internet access", and use the "Device Name". For example, `'Intel(R) Centrino(R) Advanced-N 6205'`.
+ For Mac, this works from some: `'en0: Wi-Fi (AirPort)'`, but there is an issue with VirtualBox and the Airport. You should look into using an Ethernet adaptor and something like: `'en3: Ethernet'`
+ For Linux, ...TODO...
