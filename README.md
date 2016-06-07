# OpenStack cluster with chef-provisioning

This is the testing framework for OpenStack and Chef. We leverage this to test against our changes to our [cookbooks](https://wiki.openstack.org/wiki/Chef/GettingStarted) to make sure
that you can still build a cluster from the ground up with any changes we push up.

This framework also gives us an opportunity to show different Reference Architectures and a sane example on how to start with OpenStack and Chef.

With the `master` branch of the cookbooks, which is currently tied to the base OpenStack Liberty release, this supports deploying to Ubuntu 14.04 and CentOS 7.1 for all-in-one with nova-network.  Support for all-in-one with Neutron, and multi-node support, is a work in progress.

## Prereqs

- [ChefDK](https://downloads.chef.io/chef-dk/) 0.9.0 or later
- [Vagrant](https://www.vagrantup.com/downloads.html) 1.7.2 or later with [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or some other provider

## Initial Setup Steps

```shell
$ git clone https://github.com/openstack/openstack-chef-repo.git
$ cd openstack-chef-repo
$ chef exec rake berks_vendor
```

The OpenStack cookbooks by default use databags for configuring passwords.  There are four
data_bags : *user_passwords*, *db_passwords*, *service_passwords*, *secrets*. I have a already created
the `data_bags/` directory, so you shouldn't need to make them, if you do something's broken.
See [Databags](#databags) section below for more details.

**NOTE**: If you are running Ubuntu 14.04 LTS and as your **base** compute machine, you should note that the shipped
kernel `3.13.0-24-generic` has networking issues, and the best way to resolve this is
via: `apt-get install linux-image-generic-lts-utopic`. This will install at least `3.16.0` from the Utopic hardware enablement.

## Supported Deployments

* All-in-One
  * Neutron
* Multi-Node
  * Neutron

For each deployment model, there is a corresponding readme file in the doc/ directory.  Please review that for specific details and additional setup that might be required before deploying the cloud.

## Rake Deploy Commands

These commands will spin up various OpenStack cluster configurations, the simplest being the all-in-one controller with nova-network.

For CentOS, set the environment variable REPO_OS=centos7

```bash
# All-in-one controller with neutron-network
$ chef exec rake allinone
# Multi-Node Setup with neutron-network (1 controller + 2 compute nodes)
$ chef exec rake multi_node
 ```

### Access the Controller

```bash
$ cd vms
$ vagrant ssh controller
$ sudo su -
```

### Access the Compute nodes

```bash
$ cd vms
$ vagrant ssh compute1
# OR
$ vagrant ssh compute2
$ sudo su -
```

### Testing the Controller

```bash
# Access the controller as noted above
$ source openrc
$ nova-manage version
$ nova service-list && nova hypervisor-list
$ glance image-list
$ keystone user-list
$ nova list
```

### Working with Security Groups ###

To allow SSH access to instances, a nova security group is defined as follows:

```bash
$ nova secgroup-list
$ nova secgroup-list-rules default
$ nova secgroup-create allow_ssh "allow ssh to instance"
$ nova secgroup-add-rule allow_ssh tcp 22 22 0.0.0.0/0
$ nova secgroup-list-rules allow_ssh
```

### Working with keys ###

To allow SSH keys to be injected into instance, a nova keypair is defined as follows:

```bash
# Just press Enter to all the questions
$ ssh-keygen
$ nova keypair-add --pub-key=/root/.ssh/id_rsa.pub mykey
```

#### Booting up a cirros image on the Controller

```bash
$ nova boot test --image cirros --flavor 1  --security-groups=allow_ssh --key-name=mykey
```

Wait a few seconds and the run `nova list` if Status is not Active, wait a few seconds and repeat.

Once status is active you should be able to log in via ssh to the listed IP.

```bash
$ ssh cirros@<ip address from nova list output>
```

#### Accessing the OpenStack Dashboard

If you would like to use the OpenStack dashboard you should go to https://localhost:9443 and the username and password is `admin/mypass`.

#### Verifying stack with tempest

If you ssh into the `controller` machine you can test via the most recent [tempest](https://github.com/openstack/tempest) release.

```bash
$ cd vms
$ vagrant ssh controller
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

To refresh all the cookbooks, use the following rake commands.

```bash
$ chef exec rake destroy_cookbooks
$ chef exec rake berks_vendor
```

To cleanup everything, use the following rake command.

```bash
$ chef exec rake clean
```

## Tools

See the doc/tools.md for more information.

## The provisioning cookbook

See site-cookbooks/provisioning/README.md for more information

## Databags

Some basic information about the use of databags within this repo.

```
# Show the list of databags
$ chef exec knife  data bag list -z
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
# set EDITOR env var to your editor. For PowerShell, I used nano
$ chef exec knife data bag edit secrets dispersion_auth_user -z
```

### Data bag default values
db_passwords are set to "mypass"
secrets are set to "<key>_token"
service_passwords are set to "mypass"
user_passwords are set to "mypass"

### Default encrypted data bag secret
The default secret is stored here .chef/encrypted_data_bag_secret
and referenced by .chef/knife.rb.

## Known Issues and Workarounds

### Windows Platform

When using this on a Windows platform, here are some tweaks to make this work:

- In order to get SSH to work, you will need an SSL client installed.  You can use the one that comes with [Git for Windows](http://git-scm.com/download).  You will need to append `C:\Program Files (x86)\Git\bin;` to the system PATH.

## TODOs

- Support for floating IPs
- Better instructions for multi-node network setup
- Split out the `multi-neutron-network-node` cluster also so the network node is it's own machine
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
