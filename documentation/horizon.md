Description
===========
The following roles are used in the deployment of the OpenStack Dashboard service **Horizon** as part of the OpenStack **Essex** reference deployment using Chef.

Dependency Roles
================

base
----
Every Horizon role depends on the `base` role included in the repository to ensure essential services (ntp, openssh, etc.).

mysql-master
------------
roles and underlying recipes providing database services through MySQL required for Horizon (and Keystone, Glance and Nova).

os-database
-----------
expose and provide the attributes used for configuring Horizon's database.

os-network
----------
expose and provide the attributes used for configuring and defining Horizon's network.

Horizon Roles
=============

horizon-server
--------------
