#!/bin/bash -x
## This script is for installing all the needed packages on trusty to run the chef tests with 'chef exec rake'.
## It relies on the common bootstrap.sh from openstack/cookbook-openstack-common for installing common dependencies.

curl https://raw.githubusercontent.com/openstack/cookbook-openstack-common/master/bootstrap.sh \
  --retry 3 \
  --silent \
  --show-error \
  | /bin/bash -x

# To enable cookbook Depends-On support, the Common bootstrap above will already
# get the cookbook dependencies cloned into ../openstack-cookbook-xxxx.  In order to
# have the repo tests use these cookbooks patches, the Berksfile uses the ZUUL_CHANGES
# variable to trigger using local cookbooks.
