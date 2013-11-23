# Testing with Vagrant #

## Prerequisites ##

The allinone-compute role may be tested with Vagrant, currently with Ubuntu 12.04 and 13.04. You need the following prerequisites:

1. You must have Vagrant 1.2.1 or later installed.
2. You must have a "sane" Ruby 1.9.3 environment.
3. You must have the following Vagrant plugins:

    $ vagrant plugin install vagrant-omnibus
    $ vagrant plugin install vagrant-chef-zero
    $ vagrant plugin install vagrant-berkshelf

__notes:__

* Vagrant plugins must be installed in the described order.
* If you have issues with berkshelf,  you may need to use a previous version of vagrant-chef-zero.

## Starting the allinone-compute node ##

To test with Ubuntu 12.04, run:

    $ vagrant up ubuntu1204

To test with Ubuntu 13.04, run:

    $ vagrant up ubuntu1304

## Further testing ##

Now you have an openstack, you'll probably want to be able to actually launch instances.

### Log into box,  prepare environment ###

    $ vagrant ssh ubuntu1204
    $ sudo bash
    $ source /root/openrc

### Basic health checks ###

    $ nova service-list
    $ keystone catalog

### Working with Glance images ###

    $ glance image-list

This will return the existing Cirros image which was included in the `vagrant` Environment.

### Working with Security Groups ###

    $ nova secgroup-list
    $ nova secgroup-list-rules default
    $ nova secgroup-create allow_ssh "allow ssh to instance"
    $ nova secgroup-add-rule allow_ssh tcp 22 22 0.0.0.0/0
    $ nova secgroup-list-rules allow_ssh

### Working with keys ###

    $ ssh-keygen
    $ nova keypair-add --pub-key=/root/.ssh/id_rsa.pub testing

### Create an instance ###

    $ nova flavor-list
    $ nova boot --flavor=1 --image=cirros --security-groups=allow_ssh --key-name=testing testserver

Wait a few seconds and the run `nova list` if Status is not Active, wait a few seconds and repeat.

Once status is active you should be able to log in via ssh to the listed IP.

    $ ssh cirros@192.168.100.2


# Testing with Vagabond #

We use Vagabond to do integration testing. The Vagabondfile in the root
directory of the Chef repo contains the definitions of the nodes that
are used during integration testing.

To set up Vagabond, do this:

    $ bundle exec vagabond init

When prompted, answer "N" to not overwrite the existing Vagabondfile, and then
answer "n" for all templates you don't want to use and "y" for the rest.

When running integration tests, Vagabond starts up a set of LXC containers
to represent the actual hardware nodes used in a deployment, including the
Chef server itself. The nodes we use in integration testing are the
following:

* `server` -- A hardcoded LXC instance name that contains a Chef 11 server
              that is loaded up with the Berkshelf cookbooks, the role definitions,
              and environment definitions defined in this Chef repo
* `ops` -- An LXC instance that gets all the ops-related recipes and applications
           installed in it, including databases, message queues, logging, etc
* `compute-worker` -- An LXC instance that acts as a compute worker
* `controller` -- An LXC instance that contains all the OpenStack control software

### Vagabond Local Chef Server

To start the local Chef 11 server LXC instance using Vagabond:

    $ bundle exec vagabond server up

The above will automatically upload the roles and environment
definitions in this Chef repo along with all of the cookbooks
in the Berkshelf.

To re-upload all of the cookbooks in the Berkshelf, simply do:

    $ bundle exec vagabond server upload_cookbooks

To re-upload the roles or environment files:

    $ bundle exec vagabond server upload_roles
    $ bundle exec vagabond server upload_environments

Remember that the above will install the **current** Berkshelf. Remember to
run:

    $ bundle exec berks update

before you do the `vagabond server upload_cookbooks` command.

### Test Nodes

To start any of the LXC instances that represent the different ops, controller
and worker nodes in an OpenStack environment, do:

    $ bundle exec vagabond up <NODE>

If you make changes to cookbooks and issue a `vagabond server upload_cookbooks` or
role/environment definitions, you will want to re-provision the node, which basically
ensures the node is up and runs chef-client on it:

    $ bundle exec vagabond provision <NODE>

To destroy a node:

    $ bundle exec vagabond destroy <NODE>

To entirely rebuild a node from scratch:

    $ bundle exec vagabond rebuild <NODE>

When a node is up, you can SSH into that node to run tests or investigate logs, etc:

    $ bundle exec vagabond ssh <NODE>

To see the status of all the nodes that Vagabond is managing, including the IP addresses
that the containers are bound to:

    $ bundle exec vagabond status
