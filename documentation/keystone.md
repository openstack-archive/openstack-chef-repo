Description
===========
The following roles are used in the deployment of the OpenStack Identity Service **Keystone** as part of the OpenStack **Essex** reference deployment using Chef.

Dependency Roles
================

base
----
Every Keystone role depends on the `base` role included in the repository to ensure essential services (ntp, openssh, etc.).

mysql-master
------------
roles and underlying recipes providing database services through MySQL required for Keystone (and Nova, Glance and Horizon).

os-database
-----------
expose and provide the attributes used for configuring Keystone's database.

os-network
----------
expose and provide the attributes used for configuring and defining Keystone's network.

Keystone Roles
==============

keystone
--------
