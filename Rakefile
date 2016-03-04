current_dir = File.dirname(__FILE__)
client_opts = "--force-formatter --no-color -z --config #{current_dir}/.chef/knife.rb"

task default: ["test"]

desc "Default gate tests to run"
task :test => [:rubocop, :berks_vendor, :json_check]

def run_command(command)
  if File.exist?('Gemfile.lock')
    sh %(bundle exec #{command})
  else
    sh %(chef exec #{command})
  end
end

task :destroy_all do
  Rake::Task[:destroy_machines].invoke
  run_command('rm -rf Gemfile.lock && rm -rf Berksfile.lock && rm -rf cookbooks/')
end

desc "Destroy machines"
task :destroy_machines do
  run_command("chef-client #{client_opts} destroy_all.rb")
end

desc "Vendor your cookbooks/"
task :berks_vendor do
  run_command('berks vendor cookbooks')
end

desc "Create Chef Key"
task :create_key do
  if not File.exist?('.chef/validator.pem')
    require 'openssl'
    File.binwrite('.chef/validator.pem', OpenSSL::PKey::RSA.new(2048).to_pem)
  end
end

desc "All-in-One Neutron build"
task :aio_neutron => :create_key do
  run_command("chef-client #{client_opts} vagrant_linux.rb aio-neutron.rb")
end

desc "All-in-One Nova-networking build"
task :aio_nova => :create_key do
  run_command("chef-client #{client_opts} vagrant_linux.rb aio-nova.rb")
end

desc "Multi-Neutron build"
task :multi_neutron => :create_key do
  run_command("chef-client #{client_opts} vagrant_linux.rb multi-neutron.rb")
end

desc "Multi-Nova-networking build"
task :multi_nova => :create_key do
  run_command("chef-client #{client_opts} vagrant_linux.rb multi-nova.rb")
end

desc "Blow everything away"
task clean: [:destroy_all]

# CI tasks
require 'rubocop/rake_task'
desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop)

desc "Validate data bags, environments and roles"
task :json_check do
  require 'json'
  ['data_bags/*', 'environments', 'roles'].each do |sub_dir|
    Dir.glob(sub_dir + '/*.json') do |env_file|
      puts "Checking #{env_file}"
      JSON.parse(File.read(env_file))
    end
  end
end

# Helper for running various testing commands
def _run_commands(desc, commands, openstack=true)
  puts "## Running #{desc}"
  commands.each do |command, options|
    options.each do |option|
      if openstack
        sh %(sudo bash -c '. /root/openrc && #{command} #{option}')
      else
        sh %(#{command} #{option})
      end
    end
  end
  puts "## Finished #{desc} tests"
end

# Helper for looking at the starting environment
def _run_env_queries # rubocop:disable Metrics/MethodLength
  _run_commands('basic env queries', {
    'uname' => ['-a'],
    'pwd' => [''],
    'env' => [''],
    'ifconfig' => [''] },
    false
  )
end

# Helper for setting up basic query tests
def _run_basic_queries # rubocop:disable Metrics/MethodLength
  _run_commands('basic test queries', {
    'curl' => ['-v http://localhost', '-kv https://localhost'],
    'sudo netstat' => ['-nlp'],
    'nova-manage' => ['version', 'db version'],
    'nova' => %w(--version service-list hypervisor-list net-list image-list),
    'glance-manage' => %w(db_version),
    'glance' => %w(--version image-list),
    'keystone-manage' => %w(db_version),
    'keystone' => %w(--version user-list endpoint-list role-list service-list tenant-list),
    'cinder-manage' => ['version list', 'db version'],
    'cinder' => %w(--version list),
    'heat-manage' => ['db_version', 'service list'],
    'heat' => %w(--version stack-list),
    'rabbitmqctl' => %w(cluster_status),
    'ifconfig' => [''],
    'neutron' => %w(agent-list ext-list net-list port-list subnet-list quota-list),
    'ovs-vsctl' => %w(show) }
  )
end

# Helper for setting up basic nova tests
def _run_nova_tests # rubocop:disable Metrics/MethodLength
  uuid = `sudo bash -c '. /root/openrc && cinder list | grep test_volume | cut -d " " -f 2'`
  _run_commands('nova boot tests pre', {
    'nova' => ['list', "boot test --image cirros --flavor 1 --block-device-mapping vdb=#{uuid.chomp!}:::1"],
    'sleep' => ['25'] }
  )
  _run_commands('nova boot tests post', {
    'nova' => ['list', 'show test', 'delete test'],
    'sleep' => ['25'],
    'cinder' => ['list'] }
  )
end

# Helper for setting up neutron local network
def _setup_local_network # rubocop:disable Metrics/MethodLength
  _run_commands('neutron local network setup', {
    'neutron' => ['net-create local_net --provider:network_type local',
                  'subnet-create local_net --name local_subnet 192.168.1.0/24'] }
  )
end

# Helper for setting up cinder storage volume
def _setup_cinder_volume # rubocop:disable Metrics/MethodLength
  _run_commands('cinder storage volume setup', {
    'cinder' => ['create --display_name test_volume 1'] }
  )
end

def _dump_logs
  paths = []
  %w(nova neutron keystone cinder glance heat).each do |project|
    paths << "-r \"\" /etc/#{project}/*"
    paths << "-r \"\" /var/log/#{project}/*"
  end

  _run_commands('Dump Logs', {
    'sleep' => ['25'],
    'grep' => paths }
  )
end

desc "Integration test on Infra"
task :integration => [:create_key, :berks_vendor] do
  # This is a workaround for allowing chef-client to run in local mode
  sh %(sudo mkdir /etc/chef && sudo cp .chef/encrypted_data_bag_secret /etc/chef/openstack_data_bag_secret)
  _run_env_queries

  # Three passes to make sure of cookbooks idempotency
  for i in 1..3
    puts "####### Pass #{i}"
    # Kick off chef client in local mode, will converge OpenStack right on the gate job "in place"
    sh %(sudo chef-client #{client_opts} -E integration-aio-neutron -r 'role[allinone-compute]','role[os-image-upload]','recipe[openstack-integration-test::setup]')
    _dump_logs
    _setup_local_network if i == 1
    _run_basic_queries
    _setup_cinder_volume
    _run_nova_tests
  end
  # Run the tempest formal tests, setup with the openstack-integration-test cookbook
  Dir.chdir('/opt/tempest') do
    sh %(sudo ./run_tests.sh)
  end
  # TODO (MRV) gather logs
end
