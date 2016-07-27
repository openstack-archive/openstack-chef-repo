require 'chef/provisioning/vagrant_driver'

os = 'ubuntu/xenial64'
os = 'centos/7' if ENV['REPO_OS'].to_s.include?('centos')

with_driver 'vagrant'
with_machine_options vagrant_options: {
  'vm.box' => os
}
