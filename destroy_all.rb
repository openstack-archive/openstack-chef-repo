require 'chef/provisioning'

resource_name :machine_batch do
  machines search(:node, '*:*').map(&:name)
  action :destroy
end
