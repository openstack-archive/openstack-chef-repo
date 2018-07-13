#!/usr/bin/env bash

# check data bags, roles, environment files sanity by loading them in
# chef-zero
for db in $(ls -d data_bags/* | cut -f2 -d'/');do knife data bag from file $db data_bags/$db/*.json -z --secret-file .chef/encrypted_data_bag_secret;done
for role in $(ls roles | grep json);do knife role from file $role -z;done
for env in $(ls environments | grep json);do knife environment from file $env -z ;done
