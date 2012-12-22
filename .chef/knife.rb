raise "You must set the ORGNAME environment variable" if ENV['ORGNAME'].nil?
current_dir = File.dirname(__FILE__)
user = ENV['OPSCODE_USER'] || ENV['USER']
log_level                :info
log_location             STDOUT
node_name                user
client_key               "#{current_dir}/#{user}.pem"
validation_client_name   "#{ENV['ORGNAME']}-validator"
validation_key           "#{current_dir}/#{ENV['ORGNAME']}-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/#{ENV['ORGNAME']}"
cache_type               'BasicFile'
cache_options( :path => "#{current_dir}/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]

role_path                ["#{current_dir}/../roles"]

# all your credentials are belong to us

# OpenStack
knife[:openstack_username] = ENV['OS_USERNAME']
knife[:openstack_password] = ENV['OS_PASSWORD']
knife[:openstack_auth_url] = ENV['OS_AUTH_URL']
knife[:openstack_tenant]   = ENV['OS_TENANT']

# require 'fog'
# connection = Fog::Compute.new(:provider => 'OpenStack', :openstack_username => ENV['OS_USERNAME'], :openstack_auth_url => ENV['OS_AUTH_URL'], :openstack_api_key => ENV['OS_PASSWORD'] )
