# See http://docs.opscode.com/config_rb_knife.html
# for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level :info
log_location STDOUT
node_name 'nodienode'
client_key "#{current_dir}/nodienode.pem"
validation_client_name 'chef-validator'
validation_key "#{current_dir}/validator.pem"
chef_server_url 'https://api.opscode.com/organizations/my_awesome_org'
cache_type 'BasicFile'
cache_options(path: "#{ENV['HOME']}/.chef/checksums")
cookbook_path ["#{current_dir}/../cookbooks"]
knife[:secret_file] = "#{current_dir}/encrypted_data_bag_secret"
