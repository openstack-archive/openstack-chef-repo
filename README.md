Team and repository tags
========================

[![Team and repository tags](http://governance.openstack.org/badges/openstack-chef-repo.svg)](http://governance.openstack.org/reference/tags/index.html)

<!-- Change things from this point on -->

![Chef OpenStack Logo](https://www.openstack.org/themes/openstack/images/project-mascots/Chef%20OpenStack/OpenStack_Project_Chef_horizontal.png)

# Testing framework for deploying OpenStack using Chef

This is the testing framework for OpenStack deployed using
[Chef](https://www.chef.io). We leverage this to test against our changes to our
[cookbooks](https://wiki.openstack.org/wiki/Chef/GettingStarted) to make sure
that you can still build a cluster from the ground up with any changes we
introduce.

This framework also gives us an opportunity to show different Reference
Architectures and a sane example on how to start with OpenStack using Chef.

With the `master` branch of the cookbooks, which is currently tied to the base
OpenStack Ocata release, this supports deploying to Ubuntu 16.04 and CentOS 7
in monolithic, or allinone, and non-HA multinode configurations with Neutron.
The cookbooks support a fully HA configuration, but we do not test for that as
there are far numerous paths to
HA.

## Prerequisites

- [ChefDK](https://downloads.chef.io/chef-dk/) 2.0 or later
- [Vagrant](https://www.vagrantup.com/downloads.html) 2.0 or later with
  [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or some other provider

### Getting the Code (this repo)

```shell
$ git clone https://github.com/openstack/openstack-chef-repo.git
$ cd openstack-chef-repo
```

The OpenStack cookbooks by default use encrypted data bags for configuring
passwords.  There are four data bags : *user_passwords*, *db_passwords*,
*service_passwords*, *secrets*. There already exists a `data_bags/` directory,
so you shouldn't need to create any for a proof of concept. If you do, something is wrong.
See the [Data Bags](doc/data_bags.md) doc for the gory details.

## Supported Deployments

For each deployment model, there is a corresponding file in the doc/ directory.
Please review that for specific details and additional setup that might be
required before deploying the cloud.

## Kitchen Deploy Commands

These commands will produce various OpenStack cluster configurations, the
simplest being a monolithic Compute Controller with Neutron (allinone). These
deployments are not intended to be production-ready, and will need adaptation
to your environment. This is intended for development and proof of concept
deployments.

## Kitchen Test Scenarios

### Initialize the ChefDK
```bash
$ eval "$(chef shell-init bash)"
```

### Everything self-contained (allinone)
```bash
# allinone with Neutron
$ kitchen test [centos|ubuntu]
```

### Access the machine

```bash
$ kitchen login [centos|ubuntu]
$ sudo su -
```

### Multiple nodes (non-HA)
```bash
# Multinode with Neutron (1 controller + 2 compute nodes)
$ export KITCHEN_YAML=.kitchen.multi.yaml
$ kitchen converge [centos|ubuntu|all]
$ kitchen verify [centos|ubuntu|all]
$ kitchen destroy [centos|ubuntu|all]
 ```

### Access the Controller

```bash
$ kitchen login controller-[centos|ubuntu]
$ sudo su -
```

### Access the Compute nodes

```bash
$ cd vms
$ kitchen login compute1
# OR
$ kitchen login compute2
$ sudo su -
```

### Testing The Controller

```bash
# Access the controller as noted above
$ source /root/openrc
$ nova --version
$ openstack service list && openstack hypervisor list
$ openstack image list
$ openstack user list
$ openstack server list
```

### Working With Security Groups ###

To allow SSH access to instances, a security group is defined as follows:

```bash
$ openstack security group list
$ openstack security group list default
$ openstack security group create allow_ssh --description "allow ssh to instances"
$ openstack security group rule create allow_ssh --protocol tcp --dst-port 22:22 --remote-ip 0.0.0.0/0
$ openstack security group list allow_ssh
```

### Working With Keys ###

To allow SSH keys to be injected into instance, a key pair is defined as follows:

```bash
# generate a new key pair
$ openstack keypair create mykey > mykey.pem
$ chmod 600 mykey.pem
$ openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey
# verify the key pair has been imported
$ openstack keypair list
```

#### Booting up a cirros image on the Controller

```bash
$ openstack server create --flavor 1 --image cirros --security-group allow_ssh --key-name mykey test
```

Wait a few seconds and the run `openstack server list` if Status is not Active, wait a few seconds and repeat.

Once status is active you should be able to log in using SSH, or `vagrant ssh <vm_name>`

```bash
$ ssh cirros@<ip address from openstack server list output>
```

#### Accessing The OpenStack Dashboard

If you would like to use the OpenStack dashboard you should go to https://localhost:9443 and the username and password is `admin/mypass`.

#### Verifying OpenStack With Tempest

If you log in to the `controller` machine you can test via the most recent [Tempest](https://github.com/openstack/tempest) release.

```bash
$ cd vms
$ vagrant ssh <controller>
$ sudo su -
root@controller:~ cd /opt/tempest
root@controller:/opt/tempest$ ./run_tempest.sh -V --smoke --serial

[-- snip --]

tempest.tests.test_wrappers.TestWrappers
    test_pretty_tox                                                       1.68
    test_pretty_tox_fails                                                 1.03
    test_pretty_tox_serial                                                0.61
    test_pretty_tox_serial_fails                                          0.55

Ran 233 tests in 13.869s

OK
Running flake8 ...
root@controller:/opt/tempest#
```


## Cleanup

To remove all the nodes and start over again with a different environment or different environment attribute overrides, using the following rake command.

```bash
$ chef exec rake destroy_machines
```

To refresh all cookbooks, use the following commands.

```bash
$ rm -rf cookbooks
$ chef exec rake berks_vendor
```

To clean up everything, use the following rake command.

```bash
$ chef exec rake clean
```

## Tools

See the doc/tools.md for more information.

## Data Bags

Some basic information about the use of data bags within this repo.

```
# Show the list of data bags
$ chef exec knife data bag list -z
db_passwords
secrets
service_passwords
user_passwords

# Show the list of data bag items
$ chef exec knife data bag show db_passwords -z
cinder
dash
glance
horizon
keystone
neutron
nova

# Show contents of data bag item
$ chef exec knife data bag show db_passwords nova -z
Encrypted data bag detected, decrypting with provided secret.
nova: mypass
id:   nova

# Update contents of data bag item
# set EDITOR env var to your editor. eg. EDITOR=vi
$ chef exec knife data bag edit secrets dispersion_auth_user -z
```

### Data Bag Default Values
db_passwords are set to "mypass"
secrets are set to "<key>_token"
service_passwords are set to "mypass"
user_passwords are set to "mypass"

### Default Encrypted Data Bag Secret
The default secret is stored here .chef/encrypted_data_bag_secret
and referenced by .chef/knife.rb.

When we say defaults, we mean that they are known by everyone with access to
this repository. Change these to something else before deploying for real.

## Known Issues and Workarounds

### Windows Platform

When using this on a Windows platform, here are some tweaks to make this work:

- In order to get SSH to work, you will need an SSL client installed.  You can use the one that comes with [Git for Windows](http://git-scm.com/download).  You will need to append `C:\Program Files (x86)\Git\bin;` to the system PATH.

## TODOs

- Support for floating IPs
- Better instructions for multi-node network setup
- Easier debugging. Maybe a script to pull the logs from the controller.

# License #

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
