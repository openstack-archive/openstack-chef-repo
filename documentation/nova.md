Description
===========
The following roles are used in the deployment of the OpenStack Compute service **Nova** as part of the OpenStack **Essex** reference deployment using Chef.

Dependency Roles
================

base
----
Every Nova role depends on the `base` role included in the repository to ensure essential services (ntp, openssh, etc.).

mysql-master
------------
roles and underlying recipes providing database services through MySQL required for Nova (and Keystone, Glance and Horizon).

rabbitmq-server
---------------
roles and underlying recipes providing messaging services through RabbitMQ required for Nova (and Glance).

os-database
-----------
expose and provide the attributes used for configuring Nova's database.

os-network
----------
expose and provide the attributes used for configuring and defining Nova's network.

Nova Roles
==========

allinone
--------


single-compute
--------------


single-controller
-----------------


nova-scheduler
--------------


nova-api-ec2
------------


nova-os-compute
---------------


nova-vncproxy
-------------


nova-volume
-----------

