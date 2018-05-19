.. _ci:

######################
Continuous Integration
######################

This is a list of the CI jobs that are running against most of the Chef
OpenStack cookbooks. The code that configures Zuul jobs is hosted in
`openstack-chef-repo <https://git.openstack.org/cgit/openstack/openstack-chef-repo/tree/playbooks/>`_.

.. list-table:: **CI Jobs in Chef OpenStack**
   :widths: 31 25 8 55
   :header-rows: 1

   * - Job name
     - Description
     - Voting
     - If it fails
   * - openstack-chef-repo-rake
     - It ensures the code follows the `Chef style guidelines <https://docs.chef.io/ruby.html>`_.
     - Yes
     - Read the build logs to see which part of the code does not follow the recommended patterns.
   * - openstack-chef-repo-integration
     - Functional testing job that converges OpenStack, testing using Tempest.
     - Yes
     - Read the build logs to see where the failure originated.
