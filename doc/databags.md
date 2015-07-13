# Databags

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
ceilometer
cinder
dash
glance
heat
horizon
ironic
keystone
neutron
nova

# Show contents of data bag item
$ chef exec knife data bag show db_passwords ceilometer -z
Encrypted data bag detected, decrypting with provided secret.
ceilometer: mypass
id:         ceilometer

# Update contents of data bag item
# set EDITOR env var to your editor. For powershell, I used nano


$ chef exec knife data bag edit secrets dispersion_auth_user -z
```

| data bag default values |
| ----------------------- |
| db_passwords are set to "mypass" |
| secrets are set to "<key>_token" |
| service_passwords are set to "mypass" |
| user_passwords are set to "mypass" |

## Encrypted data bag secret
The default secret is stored here `.chef/encrypted_data_bag_secret`
and referenced by `.chef/knife.rb`.

## Creating "new data_bags"

If you would like to create a new set of data_bags, first you need to update your `encrypted_data_bag_secret` with something like the following:

```
openssl rand -base64 512 | tr -d '\r\n' > encrypted_data_bag_secret
```

### Database passwords

Then you need to create new data_bags for each of the databases you'll want to use, such as:

An example json:
```json
{
  "id": "ceilometer",
  "ceilometer": "SOME_PASSWORD"
}
```

```
chef exec knife data bag create db_passwords ceilometer --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create db_passwords cinder --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create db_passwords dash --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create db_passwords glance --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create db_passwords heat --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create db_passwords horizon --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create db_passwords ironic --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create db_passwords keystone --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create db_passwords neutron --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create db_passwords nova --secret-file .chef/encrypted_data_bag_secret
```

### Swift secrets

If you're using swift, you'll need to update the attributes from [data_bags/secrets](data_bags/secrets), and the changes are [here](https://github.com/openstack/cookbook-openstack-object-storage/blob/master/README.md#attributes).

These are for anything after Juno's release. If you're doing something before Juno, please check that attributes.rb

```json
{
  "id": "swift_hash_path_prefix",
  "swift_hash_path_prefix": "SOME_PREFIX"
}
```

```
chef exec knife data bag create secrets swift_hash_path_prefix --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create secrets swift_hash_path_suffix --secret-file .chef/encrypted_data_bag_secret
```

You'll want to create a new authkey, and dispersion keys:

```
chef exec knife data bag create secrets swift_authkey --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create secrets dispersion_auth_user --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create secrets dispersion_auth_key --secret-file .chef/encrypted_data_bag_secret
```

### Neutron secrets

Next you'll want to update your neutron metadata secret:

```
chef exec knife data bag create secrets neutron_metadata_secret --secret-file .chef/encrypted_data_bag_secret
```

### Keystone secrets

You'll want to update your keystone identity bootstrap token:

```
chef exec knife data bag create secrets openstack_idenitity_bootstrap_token --secret-file .chef/encrypted_data_bag_secret
```

### Service passwords

How to update the service passwords:

```json
{
  "id": "openstack-compute",
  "openstack-compute": "SOME_PASSWORD"
}
```

```
chef exec knife data bag create service_passwords openstack-bare-metal --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create service_passwords openstack-block-storage --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create service_passwords openstack-compute --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create service_passwords openstack-image --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create service_passwords openstack-network --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create service_passwords openstack-object-storage --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create service_passwords openstack-orchestration --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create service_passwords rbd --secret-file .chef/encrypted_data_bag_secret
```

### User passwords

If you would like to change the user passwords from `mypass`:

```json
{
  "id": "guest",
  "guest": "SOME_PASSWORD"
}
```

```
chef exec knife data bag create user_passwords admin --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create user_passwords guest --secret-file .chef/encrypted_data_bag_secret
chef exec knife data bag create user_passwords mysqlroot --secret-file .chef/encrypted_data_bag_secret
```
