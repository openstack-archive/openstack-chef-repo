Description
===========

Miscellaneous library functions for OpenStack. This currently includes:

 * ip address location

Requirements
============

Uses the Ruby libraries `chef/search/query`, `ipaddr` and `uri`

Attributes
==========

`osops_networks` is a list of network names and associated CIDR. These are used in the `get_ip` functions.

Usage
=====

node['osops_networks']['localnet'] = 127.0.0.0/8

node['osops_networks']['management'] = 10.0.1.0/24

ip = get_ip_for_net("localnet")  # returns 127.0.0.1

ip = get_ip_for_net("management") # returns the address on management, or error

License and Author
==================

Author:: Justin Shepherd (<justin.shepherd@rackspace.com>)

Author:: Jason Cannavale (<jason.cannavale@rackspace.com>)

Author:: Ron Pedde (<ron.pedde@rackspace.com>)

Author:: Joseph Breu (<joseph.breu@rackspace.com>)

Author:: William Kelly (<william.kelly@rackspace.com>)

Author:: Darren Birkett (<darren.birkett@rackspace.co.uk>)

Author:: Evan Callicoat (<evan.callicoat@rackspace.com>)

Author:: Matt Ray (<matt@opscode.com>)

Copyright 2012 Rackspace, Inc.

Copyright 2012 Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
