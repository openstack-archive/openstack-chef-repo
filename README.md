# OpenStack cluster with chef-provisioning

This is the testing framework for OpenStack and Chef. We leverage this to test against our changes to our [cookbooks](https://wiki.openstack.org/wiki/Chef/GettingStarted) to make sure
that you can still build a cluster from the ground up with any changes we push up. This will eventually be tied into the gerrit workflow
and become a stackforge project.

This framework also gives us an opportunity to show different Reference Architectures and a sane example on how to start with OpenStack and Chef.

With the `master` branch of the cookbooks, which is currently tied to the base OpenStack Kilo release, this supports deploying to Ubuntu 14 and CentOS 7 platforms for all in one with nova networking.  Support for all in one neutron and multi node support is a work in progress.

Support for CentOS 6.5 and Ubuntu 12 with Icehouse is available with the stable/icehouse branch of this project.

## Prereqs

- [ChefDK](https://downloads.chef.io/chef-dk/) 0.3.6 or later
- [Vagrant](https://www.vagrantup.com/downloads.html) 1.7.2 or later with [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or some other provider

## Initial Setup Steps

```shell
$ git clone https://github.com/jjasghar/chef-openstack-testing-stack.git testing-stack
$ cd testing-stack
$ vi vagrant_linux.rb # change the 'vm.box' to the openstack platform you'd like to run.
$ chef exec rake berks_vendor
$ chef exec ruby -e "require 'openssl'; File.binwrite('.chef/validator.pem', OpenSSL::PKey::RSA.new(2048).to_pem)"
```

The stackforge OpenStack cookbooks by default use databags for configuring passwords.  There are four
data_bags : *user_passwords*, *db_passwords*, *service_passwords*, *secrets*. I have a already created
the `data_bags/` directory, so you shouldn't need to make them, if you do something's broken.
See [Databag](#Databags) section below for more details.

**NOTE**: If you are running Ubuntu 14.04 LTS and as your **base** compute machine, you should note that the shipped
kernel `3.13.0-24-generic` has networking issues, and the best way to resolve this is
via: `apt-get install linux-image-generic-lts-utopic`. This will install at least `3.16.0` from the Utopic hardware enablement.

## Supported Environments

* All in One
  * Nova networking
  * Neutron networking
* Multi-Node
  * Nova networking
  * Nuetron networking

For each environment, there's a corresponding readme file in the doc directory.  Please review that for specific details and additional setup that might be required before deploying the cloud.

## Rake Deploy Commands

These commands will spin up various OpenStack cluster configurations, the simplest being the all-in-one controller with Nova networking.

```bash
$ chef exec rake aio_nova       # All-in-One Nova-networking Controller
$ chef exec rake aio_neutron    # All-in-One Neutron Controller
$ chef exec rake multi_neutron  # Multi-Neutron Controller and 3 Compute nodes
$ chef exec rake multi_nova     # Multi-Nova-networking Controller and 3 Compute nodes
```

### Access the Controller

```bash
$ cd vms
$ vagrant ssh controller
$ sudo su -
```

### Testing the Controller

```bash
# Access the controller as noted above
$ source openrc
$ nova service-list && nova hypervisor-list
$ glance image-list
$ keystone user-list
$ nova list
```

### Working with Security Groups ###

To allow ssh access to instances, a nova security group is defined as follows:

```bash
$ nova secgroup-list
$ nova secgroup-list-rules default
$ nova secgroup-create allow_ssh "allow ssh to instance"
$ nova secgroup-add-rule allow_ssh tcp 22 22 0.0.0.0/0
$ nova secgroup-list-rules allow_ssh
```

### Working with keys ###

To allow ssh keys to be injected into instance, a nova keypair is defined as follows:

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

## Databags

Some basic information about the use of databags within this repo.

```
# Show the list of databags
$ chef exec knife  data bag list -z
db_passwords
secrets
service_passwords
user_passwords

# Show the list of databag items
$ chef exec knife data bag show db_passwords -z
ceilometer
cinder
dash
glance
heat
horizon
keystone
neutron
nova

# Show contents of databag item
$ chef exec knife data bag show db_passwords ceilometer -z
Encrypted data bag detected, decrypting with provided secret.
ceilometer: mypass
id:         ceilometer

# Update contents of databag item
# set EDITOR env var to your editor, for powershell, I used nano
$ chef exec knife data bag edit secrets dispersion_auth_user -z
```

### Databag Default Values
db_passwords are set to "mypass"
secrets are set to "<key>_token"
service_passwords are set to "mypass"
user_passwords are set to "mypass"

### Default Databag Secret
The default secret is stored here .chef\encrypted_data_bag_secret
and referenced by .chef\knife.rb.

## Known Issues and Workarounds

### Gemfile support

The ChefDK provides all the required level of gems this testing suite needs.  But there exists a Gemfile-Provisioning file that can be used as well.
You will need to replace the Gemfile with the Gemfile-Provisioning before running your gem bundling.
Note: please ignore the Gemfile, as it is needed only to pass the existing gates with older levels of gems.

### Windows Platform

When using this on a Windows platform, here are some tweaks to make this work.

- In order to get ssh to work, you will need an ssl client installed.  I used the one that came with [Git for Windows](git-scm.com/download).  I needed to append the `C:\Program Files (x86)\Git\bin;` to the system PATH.

## TODOs

- Better instructions for multi-node network setup
- Better support for aio_neutron and muilt node tests
- Support for floating ip's
- Split out the `multi-neutron-network-node` cluster also so the network node is it's own machine
- Support for swift multi node test
- Easier debugging. Maybe a script to pull the logs from the controller.
- More automated verification testing.  Tie into some amount of [tempest](https://github.com/openstack/tempest) or [refstack](https://wiki.openstack.org/wiki/RefStack)? for basic cluster testing.

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
