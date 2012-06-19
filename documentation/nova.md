base
database
rabbitmq
keystone
glance
nova::setup
    nova::common : packages, /etc/nova/ nova.conf .novarc
    configure DB connection, create networks
nova::scheduler
nova::api
nova::volume
nova::vncproxy
horizon

     "recipe[nova::config]",
     "recipe[nova::mysql]",
          "recipe[rabbitmq]",
         "recipe[nova::rabbit]",
         "recipe[nova::api]",
         "recipe[nova::network]",
         "recipe[nova::scheduler]",
         "recipe[nova::vncproxy]",
         "recipe[nova::volume]",
         "recipe[nova::project]",
         "recipe[nova::monitor]"
