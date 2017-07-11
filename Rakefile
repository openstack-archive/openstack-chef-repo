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
  run_command("chef-client #{client_opts} -o 'provisioning::destroy_all'")
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

desc "All-in-One build"
task :allinone => :create_key do
  run_command("chef-client #{client_opts} -o 'provisioning::allinone'")
end

desc "Multinode build"
task :multinode => :create_key do
  run_command("chef-client #{client_opts} -o 'provisioning::multinode'")
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
  puts "## Finished #{desc}"
end

# use the correct environment depending on platform
if File.exist?('/usr/bin/apt-get')
  @platform = 'ubuntu16'
elsif File.exist?('/usr/bin/yum')
  @platform = 'centos7'
end

# Helper for looking at the starting environment
def _run_env_queries # rubocop:disable Metrics/MethodLength
    _run_commands('basic common env queries', {
      'uname' => ['-a'],
      'pwd' => [''],
      'env' => ['']},
      false
    )
  case @platform
  when 'ubuntu16'
    _run_commands('basic debian env queries', {
      'ifconfig' => [''],
      'cat' => ['/etc/apt/sources.list']},
      false
    )
  when 'centos7'
    _run_commands('basic rhel env queries', {
      '/usr/sbin/ip' => ['addr'],
      'cat' => ['/etc/yum.repos.d/*']},
      false
    )
  end
end

# Helper for setting up basic query tests
def _run_basic_queries # rubocop:disable Metrics/MethodLength
  _run_commands('basic common test queries', {
      'sudo netstat' => ['-nlp'],
      'nova-manage' => ['version', 'db version'],
      'nova' => %w(--version service-list hypervisor-list flavor-list),
      'glance-manage' => %w(db_version),
      'glance' => %w(--version image-list),
      'keystone-manage' => %w(db_version),
      'openstack' => ['--version', 'user list', 'endpoint list', 'role list',
                      'service list', 'project list',
                      'network agent list', 'extension list --network ',
                      'network list', 'subnet list'],
      'neutron' => %w(port-list quota-list),
      'ovs-vsctl' => %w(show) }
    )
  case @platform
  when 'ubuntu16'
    _run_commands('basic debian test queries', {
      'rabbitmqctl' => %w(cluster_status),
      'ip' => ['addr', 'route', '-6 route']}
    )
  when 'centos7'
    _run_commands('basic rhel test queries', {
      '/usr/sbin/rabbitmqctl' => %w(cluster_status),
      '/usr/sbin/ip' => ['addr', 'route', '-6 route']}
    )
  end
end

# Helper for setting up basic nova tests
def _run_nova_tests(pass) # rubocop:disable Metrics/MethodLength
  _run_commands('nova server create', {
    'openstack' => ['server list', "server create --image cirros --flavor m1.nano test#{pass}"],
    'sleep' => ['40'] }
  )
  _run_commands('nova server cleanup', {
    'openstack' => ['server list', "server show test#{pass}", "server delete test#{pass}"],
    'sleep' => ['15'] }
  )
 _run_commands('nova server query', {
    'openstack' => ['server list'] }
  )
end

# Helper for setting up neutron local network
def _setup_local_network # rubocop:disable Metrics/MethodLength
  _run_commands('neutron local network setup', {
    'openstack' => ['network create --share local_net', 'subnet create --network local_net --subnet-range 192.168.180.0/24 local_subnet'] }
  )
end

# Helper for setting up tempest and upload the default cirros image.
def _setup_tempest(client_opts)
  sh %(sudo chef-client #{client_opts} -E integration-#{@platform} -r 'recipe[openstack-integration-test::setup]')
end

def _save_logs(prefix, log_dir)
  sh %(sleep 25)
  %w(nova neutron keystone glance apache2 rabbitmq mysql-default openvswitch mariadb).each do |project|
    sh %(mkdir -p #{log_dir}/#{prefix}/#{project})
    sh %(sudo cp -rL /etc/#{project} #{log_dir}/#{prefix}/#{project}/etc || true)
    sh %(sudo cp -rL /var/log/#{project} #{log_dir}/#{prefix}/#{project}/log || true)
  end
end

desc "Integration test on Infra"
task :integration => [:create_key, :berks_vendor] do
  log_dir = ENV['WORKSPACE']+'/logs'
  # This is a workaround for allowing chef-client to run in local mode
  sh %(sudo mkdir -p /etc/chef && sudo cp .chef/encrypted_data_bag_secret /etc/chef/openstack_data_bag_secret)
  _run_env_queries

  # Install mysql2 gem to avoid hitting mirror issues
  sh %(wget https://rubygems.org/downloads/mysql2-0.4.5.gem)
  sh %(sudo apt-get install -y libmysqlclient-dev)
  sh %(chef exec gem install -N ./mysql2-0.4.5.gem)

  # Three passes to make sure of cookbooks idempotency
  for i in 1..3
    begin
    puts "####### Pass #{i}"
    # Kick off chef client in local mode, will converge OpenStack right on the gate job "in place"
    sh %(sudo chef-client #{client_opts} -E integration-#{@platform} -r 'role[minimal]')
    if i == 1
      _setup_tempest(client_opts)
      _setup_local_network
    end
    _run_basic_queries
    _run_nova_tests(i)

    rescue => e
      raise "####### Pass #{i} failed with #{e.message}"
    ensure
      # make sure logs are saved, pass or fail
      _save_logs("pass#{i}", log_dir)
      sh %(sudo chown -R $USER #{log_dir}/pass#{i})
      sh %(sudo chmod -R go+rx #{log_dir}/pass#{i})
    end
  end
  # Run the tempest formal tests, setup with the openstack-integration-test cookbook
   Dir.chdir('/opt/tempest') do
     sh %(sudo -H /opt/tempest-venv/tempest.sh)
   end
end
