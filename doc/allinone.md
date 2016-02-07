# All in One with Neutron

Note: Default operating system is Ubuntu. If you would like CentOS, set env var REPO_OS=centos7

## Networking setup

Changes need to be made to the allinone.rb file.

### Device interface

OVS needs to bridge in an adaptor for internet access. An attempt
has been made to work out of the box, however it is quite probable
you'll need to specify the bridge to use. You can set the environment
variable `OS_BRIDGE` before running the vagrant command to set it. 

For example on my Ubuntu laptop I run `export OS_BRIDGE=eth0` before
running the rake commands.

Note: To see a list of virtualbox network interface names use:
    `$ vboxmanage list bridgedifs`

+ For Windows 7, open the Control Panel, Network and Internet, Network Connections.  Look in the Connectivity column for a row with "Internet access", and use the "Device Name". For example, `'Intel(R) Centrino(R) Advanced-N 6205'`.
+ For Mac, this works from some: `'en0: Wi-Fi (AirPort)'`, but there is an issue with VirtualBox and the Airport. You should look into using an Ethernet adaptor and something like: `'en3: Ethernet'`
+ For Linux, ...TODO...
