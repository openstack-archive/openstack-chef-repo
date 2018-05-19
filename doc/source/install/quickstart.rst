.. _quickstart-test-kitchen:

`Test Kitchen`_ is a no-fuss, no BS way to get a Chef OpenStack build for:

* development of OpenStack or applications on top of it
* a reference for how the services fit together
* a simple lab environment

.. _Test Kitchen: https://kitchen.ci/

Test Kitchen builds are not recommended for production deployments, but they can work in
a pinch when you just need OpenStack.

At an absolute minimum, you should use the following resources. What is listed
is currently used in CI for the gate checks, as well as the tested minimum:

* 8 vCPU (tests as low as 4, but it tends to get CPU bound)
* 8 GB RAM (7 GB sort of works, but it's tight - expect OOM/slowness)
* 50 GB free disk space on the root partition

Recommended server resources:

* CPU/motherboard that supports `hardware-assisted virtualization`_
* 8 CPU cores
* 16 GB RAM
* 80 GB free disk space on the root partition, or 50+ GB on a blank secondary volume.

It is `possible` to perform builds within a virtual machine for
demonstration and evaluation, but your virtual machines will perform poorly.
For production workloads, multiple nodes for specific roles are recommended.

.. _hardware-assisted virtualization: https://en.wikipedia.org/wiki/Hardware-assisted_virtualization

Building with Test Kitchen
--------------------------

There are three basic steps to building OpenStack with Test Kitchen, with an optional first step should you need to customize your build:

* Configuration *(this step is optional)*
* Install and bootstrap the Chef Development Kit
* Run Test Kitchen

When building on a new server, it is recommended that all system
packages are updated and then rebooted into the new kernel:

.. note:: Execute the following commands and scripts as the root user.

.. code-block:: shell-session

  ## Ubuntu
  # apt-get update
  # apt-get dist-upgrade
  # reboot

.. code-block:: shell-session

  ## CentOS
  # yum upgrade
  # reboot

Start by cloing the OpenStack chef-repo repository and changing into the root directory:

.. code-block:: shell-session

  # git clone https://git.openstack.org/openstack/openstack-chef-repo \
      /opt/openstack-chef-repo
  # cd openstack-chef-repo

Next, switch to the applicable branch/tag to be deployed. Note that deploying
from the head of a branch may result in an unstable build due to changes in
flight and upstream OpenStack changes. For a test (not a development) build, it
is usually best to checkout the latest tagged version.

.. parsed-literal::

   ## List all existing branches.
   # git branch -v

   ## Checkout the stable branch
   # git checkout |current_release_git_branch_name|

.. note::
   The |current_release_formal_name| release is compatible with Ubuntu 16.04
   (Xenial Xerus) and CentOS 7

By default the cookbooks deploy all OpenStack services with sensible defaults
for the purpose of a gate check, development or testing system.

Deployers have the option to change how the build is configured by overriding
in the respective kitche YAML file. This can be useful when you want to make
use of different services or test new cookbooks.

To use a different driver for Test Kitchen, such as for a multi-node
development environment, pass the ``KITCHEN_YAML`` environment variable as an
additional option to the ``kitchen`` command. For example, if you want to
deploy a multi-node development environment, instead of an AIO, then execute:

.. code-block:: shell-session

  # KITCHEN_YAML=.kitchen.multi.yml kitchen converge [7|1604|all]


