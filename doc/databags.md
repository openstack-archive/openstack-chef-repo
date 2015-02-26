# Databags

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

## Databag Default Values
db_passwords are set to "mypass"
secrets are set to "<key>_token"
service_passwords are set to "mypass"
user_passwords are set to "mypass"

## Default Databag Secret
The default secret is stored here .chef\encrypted_data_bag_secret
and referenced by .chef\knife.rb.
