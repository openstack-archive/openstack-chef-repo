current_dir = File.dirname(__FILE__)
client_opts = "--force-formatter --no-color -z --config #{current_dir}/.chef/knife.rb"

task default: ['test']

desc 'Default gate tests to run'
task test: [:rubocop, :berks_vendor, :json_check]

def run_command(command)
  if File.exist?('Gemfile.lock')
    sh %(bundle exec #{command})
  else
    sh %(chef exec #{command})
  end
end

task :destroy_all do
  run_command('rm -rf Gemfile.lock && rm -rf Berksfile.lock && rm -rf cookbooks/')
end

desc 'Vendor your cookbooks/'
task :berks_vendor do
  run_command('berks vendor cookbooks')
end

desc 'Create Chef Key'
task :create_key do
  unless File.exist?('.chef/validator.pem')
    require 'openssl'
    File.binwrite('.chef/validator.pem', OpenSSL::PKey::RSA.new(2048).to_pem)
  end
end

desc 'Blow everything away'
task clean: [:destroy_all]

# CI tasks
require 'cookstyle'
require 'rubocop/rake_task'
desc 'Run RuboCop'
RuboCop::RakeTask.new do |task|
  task.options << '--display-cop-names'
end

desc 'Validate data bags, environments and roles'
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
def _run_commands(desc, commands, openstack = true)
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
def _run_env_queries
  _run_commands('basic common env queries', {
                  'uname' => ['-a'],
                  'pwd' => [''],
                  'env' => [''] },
    false)
  case @platform
  when 'ubuntu16'
    _run_commands('basic debian env queries', {
                    'ifconfig' => [''],
                    'cat' => ['/etc/apt/sources.list'] },
      false)
  when 'centos7'
    _run_commands('basic rhel env queries', {
                    '/usr/sbin/ip' => ['addr'],
                    'cat' => ['/etc/yum.repos.d/*'] },
    false)
  end
end

# Helper for setting up basic query tests
def _run_basic_queries
  _run_commands('basic common test queries',
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
                'ovs-vsctl' => %w(show))
  case @platform
  when 'ubuntu16'
    _run_commands('basic debian test queries',
                  'rabbitmqctl' => %w(cluster_status),
                  'ip' => ['addr', 'route', '-6 route'])
  when 'centos7'
    _run_commands('basic rhel test queries',
                  '/usr/sbin/rabbitmqctl' => %w(cluster_status),
                  '/usr/sbin/ip' => ['addr', 'route', '-6 route'])
  end
end

def _save_logs(prefix, log_dir)
  sh %(sleep 25)
  %w(nova neutron keystone glance apache2 rabbitmq mysql mysql-default openvswitch mariadb).each do |project|
    sh %(mkdir -p #{log_dir}/#{prefix}/#{project})
    sh %(sudo cp -rL /etc/#{project} #{log_dir}/#{prefix}/#{project}/etc || true)
    sh %(sudo cp -rL /var/log/#{project} #{log_dir}/#{prefix}/#{project}/log || true)
  end
end

desc 'Integration test on Infra'
task integration: [:create_key, :berks_vendor] do
  log_dir = ENV['WORKSPACE'] + '/logs'
  sh %(mkdir #{log_dir})
  # This is a workaround for allowing chef-client to run in local mode
  sh %(sudo mkdir -p /etc/chef && sudo cp .chef/encrypted_data_bag_secret /etc/chef/openstack_data_bag_secret)
  _run_env_queries

  # Three passes to ensure idempotency. prefer each to times, even if it
  # reads weird
  for i in 1..3 do
    begin
      puts "####### Pass #{i}"
      # Kick off chef client in local mode, will converge OpenStack right on the gate job "in place"
      sh %(sudo chef-client #{client_opts} -E integration -r 'role[minimal]' > #{log_dir}/chef-client-pass#{i}.txt 2>&1 )
      _run_basic_queries
    rescue => e
      raise "####### Pass #{i} failed with #{e.message}"
    ensure
      # make sure logs are saved, pass or fail
      _save_logs("pass#{i}", log_dir)
      sh %(sudo chown -R $USER #{log_dir}/pass#{i})
      sh %(sudo chmod -R go+rx #{log_dir}/pass#{i})
    end
  end
end
