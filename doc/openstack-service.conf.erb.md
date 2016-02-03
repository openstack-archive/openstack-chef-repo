# Render all openstack-service configuration files from attributes

Note: This functionality has been added in mitaka and replaces most of the
previously existing template files to generate service configurations like
nova.conf, neutron.conf or even ml2_conf.ini.

# Usage

All service configuration files following the [INI file
format](https://en.wikipedia.org/wiki/INI_file) can be created with the template
from the [openstack-common cookbook]
(https://github.com/openstack/cookbook-openstack-common/blob/master/templates/default/openstack-service.conf.erb).

The attributes to create for example the neutron.conf have to follow this
format:

```
default['openstack']['network']['conf'][$SECTION][$PROPERTY][$VALUE]
```

In the case given above, you first have to select the proper section ($SECTION)
like 'DEFAULT' or 'keystone_authtoken'. After that you can simply select the
property (e.g. 'log_file', 'verbose' or 'password') and its value (e.g.
'/var/log/neutron/neutron-server.log', true or 'mypass'). The given examples would render
something similar to this:

```
['DEFAULT']
log_file = /var/log/neutron/neutron-server.log
verbose = true
['keystone_authtoken']
password = mypass
```

The exact same logic is used for most services (currently keystone, nova,
neutron (conf and plugin files), cinder and glance) and will be adapted for all
other services and config files throughout the openstack cookbooks if possible.

TODO: add more specifics of the used defaults to each service cookbook and link
these sections here
