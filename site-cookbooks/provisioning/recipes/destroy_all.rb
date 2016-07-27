require 'chef/provisioning'

machine_batch do
  machines search(:node, '*:*').map(&:name)
  action :destroy
end
