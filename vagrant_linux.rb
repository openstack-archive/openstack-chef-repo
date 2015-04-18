require 'chef/provisioning/vagrant_driver'

vagrant_box 'centos7.1' do
  url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.1_chef-provisionerless.box'
end

vagrant_box 'ubuntu14' do
  url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box'
end

with_driver "vagrant:#{File.dirname(__FILE__)}/vms"
with_machine_options vagrant_options: {
  # if you would like to use centos7 you'll need to
  # update the chef_environment in the main recipe files (aio or multi _nova)
  'vm.box' => 'ubuntu14'
}
