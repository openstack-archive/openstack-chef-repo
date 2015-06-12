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

## data bag default values
db_passwords are set to "mypass"
secrets are set to "<key>_token"
service_passwords are set to "mypass"
user_passwords are set to "mypass"

## Encrypted data bag secret
The default secret is stored here .chef/encrypted_data_bag_secret
and referenced by .chef/knife.rb.
