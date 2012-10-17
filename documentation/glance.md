Description
===========
The following roles are used in the deployment of the OpenStack Image Service **Glance** as part of the OpenStack **Essex** reference deployment using Chef.

Dependency Roles
================

base
----
Every Glance role depends on the `base` role included in the repository to ensure essential services (ntp, openssh, etc.).

mysql-master
------------
roles and underlying recipes providing database services through MySQL required for Glance (and Keystone, Nova and Horizon).

rabbitmq-server
---------------
roles and underlying recipes providing messaging services through RabbitMQ required for Glance (and Nova).

os-Database
-----------
expose and provide the attributes used for configuring Glance's database.

os-network
----------
expose and provide the attributes used for configuring and defining Glance's network.

Glance Roles
============
These roles are utilized by the osops-utils package for mapping ip addresses to services via search.

glance-api
----------

glance-registry
---------------

glance-images
-------------
Attributes enabling uploading images to Glance as well as listing the images to be used. There is an example of an Ubuntu 12.04 "precise" image from a local server. There are additional examples within the `attributes/default.rb` file included within the Glance cookbook.
