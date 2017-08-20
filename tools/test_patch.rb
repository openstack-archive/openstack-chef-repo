# Test Patches
#
# Test patches against the testing repo
#
# Author: Mark Vanderwiel (<vanderwl@us.ibm.com>)
# Copyright (c) 2015, IBM, Corp.

require 'fileutils'
require 'English'
require 'chef/mixin/shell_out'
require 'open3'
require 'thor'

def version
  '0.1.0'
end

def run(command, verbose = true)
  puts "## Running command: [#{Dir.pwd}] $ #{command}"
  live_stream = STDOUT
  live_stream = nil unless verbose
  runner = Mixlib::ShellOut.new(command, live_stream: live_stream, timeout: 1800).run_command
  runner.error!
  runner.stdout
end

def check_dependencies
  puts '## Checking dependencies'
  run('chef --version')
  run('vagrant --version')
end

def get_gerrit_user(user)
  return user unless user.to_s.empty?
  puts '## Using git config to find gitreview.username'
  git_config = run('git config -l', false)
  /^gitreview.username=(?<user>.*)$/i =~ git_config
  abort 'Error! Gerrit user could not be found, please use --username' if user.to_s.empty?
  user
end

def get_patch_info(user, patch)
  puts "## Gathering information for patch: #{patch} with user: #{user}"
  patch_info = if user == 'jenkins'
                 run("ssh -p 29418 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no #{user}@review.openstack.org gerrit query --current-patch-set #{patch}", false)
               else
                 run("ssh -p 29418 #{user}@review.openstack.org gerrit query --current-patch-set #{patch}", false)
               end
  %r{^\s*project: openstack\/(?<patch_project>.*)$}i =~ patch_info
  /^\s*ref: (?<patch_ref>.*)$/i =~ patch_info
  abort "Error! Patch: #{patch} not valid" if patch_project.nil?
  patch_cookbook = patch_project.gsub('cookbook-', '')
  puts "## Patch project: #{patch_project}"
  puts "## Patch cookbook: #{patch_cookbook}"
  puts "## Patch ref: #{patch_ref}"
  abort "Error! Only cookbook-openstack-* patches allowed, not from project: #{patch_project}" unless patch_project[/cookbook-openstack-.*/]
  { patch: patch, project: patch_project, cookbook: patch_cookbook, ref: patch_ref }
end

def add_patch(patch_info)
  puts "## Adding patch: #{patch_info[:patch]} to cookbook: #{patch_info[:cookbook]}"
  run("git clone --depth 1 git@github.com:openstack/#{patch_info[:project]}.git")
  Dir.chdir(patch_info[:project]) do
    run("git fetch https://review.openstack.org/openstack/#{patch_info[:project]} #{patch_info[:ref]}")
    run('git checkout FETCH_HEAD')
  end
end

def run_tempest
  puts '## Starting tempest tests'
  Dir.chdir('vms') do
    run("vagrant ssh -c \"sudo bash -c 'cd /opt/tempest && ./run_tests.sh -V'\" controller")
  end
end

def run_basic_queries
  puts '## Starting basic query tests'
  {
    'nova-manage' => ['version', 'db version'],
    'nova' => %w(--version service-list hypervisor-list net-list image-list),
    'glance-manage' => %w(db_version),
    'glance' => %w(--version image-list),
    'keystone-manage' => %w(db_version),
    'keystone' => %w(--version user-list endpoint-list role-list service-list tenant-list),
    'cinder-manage' => ['version list', 'db version'],
    'cinder' => %w(--version list),
    'rabbitmqctl' => %w(cluster_status),
  }.each do |cli, commands|
    commands.each do |command|
      Dir.chdir('vms') do
        run("vagrant ssh -c \"sudo bash -c 'source /root/openrc && #{cli} #{command}'\" controller")
      end
    end
  end
  puts '## Finished basic query tests'
end

def get_test_dir(env, os, patches)
  patch = 'master'
  patch = patches.tr(' ', '-') unless patches.to_s.empty?
  dir_name = "test-#{env}-#{os}-#{patch}"
  puts "## Repo dir: #{dir_name}"
  dir_name
end

# Class to run the CLI
class MyCLI < Thor
  desc 'test', 'Spin up test repo with optional patches'
  long_desc <<-LONGDESC
      This will run the test suite.  There are options to include one or more patches using the gerrit review number.
      The test will run in a new directory called test-<env>-<os>-<patch>, where allinone is the default environment,
      ubuntu14 is the default os platform and master (no patches) is the default for patch.

      For patches, the tool will try to find your gerrit review name using the "git config -l".  If the tool
      cannot automatically find your gerrit review name, use the -u option to specify it.\n

      Examples:

      "$ chef exec ruby test_patch test"\n
      This will run the allinone against the master branch.

      "$ chef exec ruby test_patch test -t"\n
      This will run the allinone against the master branch and run the tempest suite.

      "$ chef exec ruby test_patch test -p 161495 -u kramvan"\n
      This will run the allinone against the master branch including the 161495 patch set.

      "$ chef exec ruby test_patch test -p 161495,123456 -u kramvan"\n
      This will run the allinone against the master branch including patches 161495 and 123456.

      "$ chef exec ruby test_patch test -p 161495 -i"\n
      This will run the allinone against the master branch including the 161495 patch set and
      run the converge a second time to help check for idempotentcy. Also, in this case the
      gerrit username was automatically found.

      "$ chef exec ruby test_patch test -k -s"\n
      This is a developer run.  The -s will skip the setup steps and just run the converge and tests
      again.  This allows a developer to tweak and debug a node and then try converge again.

LONGDESC
  option :patches, aliases: :p, default: nil, banner: ' Gerrit patch numbers: xxx,zzz, defaults to no patches just use master branch.'
  option :env, aliases: :e, default: 'allinone', banner: ' Test environment to run.'
  option :os, aliases: :o, default: 'ubuntu14', banner: ' OS to use, ubuntu14 or centos7.'
  option :idempotent, aliases: :i, default: false, type: :boolean, banner: ' Run converge a second time to help check for idempotentcy.'
  option :query, aliases: :q, default: true, type: :boolean, banner: ' Run basic test queries after converge completes.'
  option :tempest, aliases: :t, default: false, type: :boolean, banner: ' Run Tempest suite.'
  option :keep, aliases: :k, default: false, type: :boolean, banner: ' Keep the environment, do not run \"rake destroy_machines\".'
  option :username, aliases: :u, banner: ' Gerrit user name used to fetch a patch if tool cannot automatically find it in git config.'
  option :skip, aliases: :s, banner: ' Skip all source changes, just run converge and tests again.  For development after manually tweaking a node.'
  def test
    puts "## Starting repo test version: #{version} environment: #{options[:env]} on os: #{options[:os]}"
    ENV['REPO_OS'] = options[:os]

    # TODO: Allow more flexibility with dependencies
    check_dependencies

    dir_name = get_test_dir(options[:env], options[:os], options[:patches])
    Dir.mkdir(dir_name) unless Dir.exist?(dir_name)
    Dir.chdir(dir_name) do
      if options[:patches] && !options[:skip]
        user = get_gerrit_user(options[:username])
        options[:patches].split(',').each do |patch|
          patch_info = get_patch_info(user, patch)
          add_patch(patch_info)
        end
      end

      run('git clone --depth 1 git@github.com:openstack/openstack-chef-repo.git') unless options[:skip]
      Dir.chdir('openstack-chef-repo') do
        ENV['ZUUL_CHANGES'] = options[:patches]
        run('chef exec rake berks_vendor') unless options[:skip]

        (1..(options[:idempotent] ? 2 : 1)).each do |pass|
          puts "## Starting Converge pass: #{pass}"
          run("chef exec rake #{options[:env]}")
          run_basic_queries if options[:query]
          run_tempest if options[:tempest]
          puts "## Finished Converge pass: #{pass}"
        end

        run('chef exec rake destroy_machines') unless options[:keep]
      end
    end

    FileUtils.rm_rf(dir_name) unless options[:keep]
    puts "## Finished repo test version: #{version} environment: #{options[:env]} on os: #{options[:os]}"
  end
end

MyCLI.start(ARGV)
