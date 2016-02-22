require 'chef/provisioning/vagrant_driver'

vagrant_box 'centos7.2' do
  url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.2_chef-provisionerless.box'
end

vagrant_box 'ubuntu14' do
  url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box'
end

os = 'ubuntu14'
os = 'centos7.2' if ENV['REPO_OS'].to_s.include?('centos')

with_driver "vagrant:#{File.dirname(__FILE__)}/vms"
with_machine_options vagrant_options: {
  'vm.box' => os
}
