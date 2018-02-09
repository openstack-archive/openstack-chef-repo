# # encoding: utf-8

# Inspec test for openstack-chef-repo

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# There is no console output during runtime, check log file instead.

describe command('sudo bash -c "cd /opt/tempest && ' \
                 'sudo /opt/tempest-venv/tempest.sh | ' \
                 'tee /root/inspec-tempest-$(date -Iminutes).log &&' \
                 'exit \${PIPESTATUS[0]}"') do
  its('exit_status') { should eq 0 }
end
