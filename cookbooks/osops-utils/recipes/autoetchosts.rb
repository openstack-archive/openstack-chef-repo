#
# Cookbook Name:: osops-utils
# Recipe:: autoetchosts
#
# Copyright 2012, Rackspace Hosting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'tempfile'
require 'fileutils'

# Find all nodes, sorting by Chef ID so their
# order doesn't change between runs.
if Chef::Config[:solo]
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else
  hosts = search(:node, "chef_environment:#{node.chef_environment}")

  Chef::Log.info("osops-utils/autoetchosts: Setting up /etc/hosts for #{hosts.length} entries")

  Chef::Log.info("osops-utils/autoetchosts: reading /etc/hosts")
  hostsfile = Array.new
  File.open("/etc/hosts", "r") do |infile|
    marker=0
    while (line = infile.gets)
      if line =~ /^# \*\*\* START CHEF MANAGED HOSTS - DO NOT DELETE THIS MARKER \*\*\*$/i
        marker=1
      end
      if (marker==1)
        # drop this line on the ground
      else
        # store this line for later use
        marker=0
        hostsfile << line
      end
      if line =~ /^# \*\*\* END CHEF MANAGED HOSTS - DO NOT DELETE THIS MARKER\*\*\*$/i
        # drop this line on the ground
        marker=0
      end
    end
  end

  hostsfile << "# *** START CHEF MANAGED HOSTS - DO NOT DELETE THIS MARKER ***\n"
  hostsfile << "# *** Do not edit anything between the START and END blocks ***\n"
  hostsfile << "# *** Chef will overwrite anything between these blocks ***\n"
  hosts.each do |host|
    begin
      ip = ::Chef::Recipe::IPManagement.get_ip_for_net("management",host)
      stra = String.new("#{ip}    #{host["fqdn"]} #{host["hostname"]}\n")
      hostsfile << stra
    rescue
      Chef::Log.info("osops-utils/autoetchosts: skipping this node because it doesn't have a network assigned yet")
    end
  end
  hostsfile << "# *** END CHEF MANAGED HOSTS - DO NOT DELETE THIS MARKER***\n"

  f = Tempfile.new('hosts', Chef::Config[:file_cache_path])
  tmppath = f.path
  Chef::Log.info("osops-utils/autoetchosts: writing #{tmppath}")
  hostsfile.each do |line|
    f.write(line)
  end
  f.close
  Chef::Log.info("osops-utils/autoetchosts: moving #{tmppath} to /etc/hosts")
  FileUtils.chmod(0644,tmppath);
  FileUtils.mv(tmppath,'/etc/hosts', :force => true)
end
