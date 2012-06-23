#!/usr/bin/env ruby

require "chef/search/query"
require "ipaddr"
require "uri"

module RCB
  # These are the new endpoint functions, that return much more information about
  # endpoints.  Sufficient to configure something, I hope.  :/

  # Get the bind information necessary for a service.
  # ex:  IPManagement.get_bind_endpoint("keystone","admin")
  # { "host" => "10.1.0.2",
  #   "port" => 35357,
  #   "scheme" => "http",
  #   "path" => "/v2.0",
  #   "uri" => "http://10.1.0.2:35357/v2.0"
  #   "network" => "management"
  #
  # To define this resource, there must be a service entries like...
  # node["keystone"]["services"]["admin"] =
  # { "network" => "management", "port" => 35357 }
  #
  # IP address is derived from required network, unless overridden
  # Protocol defaults to "http", path defaults to "/".  If a URI
  # is specified, it overrides all other settings, otherwise it is
  # composed from the individual components

  def rcb_exit_error(msg)
    Chef::Log.error(msg)
    raise msg
  end

  def rcb_safe_deref(hash, path)
    current = hash

    Chef::Log.debug("Searching for #{path} in #{hash}")
    path_ary = path.split(".")
    path_ary.each do |k|
      if current and current.has_key?(k)
        current = current[k]
      else
        current = nil
      end
    end

    current
  end

  # stub until we can migrate out the IPManagement stuff
  def get_ip_for_net(network, nodeish = nil)
    _, ip = get_if_ip_for_net(network, nodeish)
    return ip
  end

  def get_if_for_net(network, nodeish = nil)
    iface, _ = get_if_ip_for_net(network, nodeish)
    return iface
  end

  def get_if_ip_for_net(network, nodeish = nil)
    nodish = node unless nodeish

     if network == "all"
      return "0.0.0.0"
    end

    if network == "localhost"
      return "127.0.0.1"
    end

    if not (node.has_key?("osops_networks") and node["osops_networks"].has_key?(network)) then
      error = "Can't find network #{network}"
      Chef::Log.error(error)
      raise error
    end

    net = IPAddr.new(node["osops_networks"][network])
    node["network"]["interfaces"].each do |interface|
      interface[1]["addresses"].each do |k,v|
        if v["family"] == "inet6" or v["family"] == "inet" then
          addr=IPAddr.new(k)
          if net.include?(addr) then
            return [interface[0], k]
          end
        end
      end
    end

    error = "Can't find address on network #{network} for node"
    Chef::Log.error(error)
    raise error
  end

  def get_bind_endpoint(server, service, nodeish=nil)
    retval = {}
    nodeish = node unless nodeish

    if svc = rcb_safe_deref(nodeish, "#{server}.services.#{service}")
      retval["path"] = svc["path"] || "/"
      retval["scheme"] = svc["scheme"] || "http"
      retval["port"] = svc["port"] || "80"

      # if we have an endpoint, we'll just parse the pieces
      if svc.has_key?("uri")
        uri = URI(svc["uri"])
        ["path", "scheme", "port", "host"].each do |x|
          retval.merge(x => uri.send(x))
        end
      elsif svc.has_key?("host")
        retval["host"] = svc["host"]
        retval["uri"] = "#{retval['scheme']}://#{retval['host']}:#{retval['port']}"
        retval["uri"] += retval["path"]
      else
        # we'll get the network from the osops network
        retval["host"] = Chef::Recipe::IPManagement.get_ip_for_net(svc["network"], nodeish)
        retval["uri"] = "#{retval['scheme']}://#{retval['host']}:#{retval['port']}"
        retval["uri"] += retval["path"]
      end

      retval
    else
      Chef::Log.warn("Cannot find server/service #{server}/#{service}")
      nil
    end
  end

  # Get the access endpoint for a role.
  #
  # If a role search returns no results, but the role is in our
  # current runlist, use the bind endpoint from the local node
  # attributes.
  #
  # If a role search returns more than one result, then return
  # the LB config for that service
  #
  # If the role search returns exactly one result, then use
  # the bind endpoint for the service according to that nodes attributes
  #

  def get_access_endpoint(role, server, service)
    query = "roles:#{role} AND chef_environment:#{node.chef_environment}"
    result, _, _ = Chef::Search::Query.new.search(:node, query)

    if result.length == 1 and result[0].name == node.name
      Chef::Log.debug("Found 1 result for #{role}/#{server}/#{service}, and it's me!")
      result = [node]
    elsif result.length == 0 and node["roles"].include?(role)
      Chef::Log.debug("Found 0 result for #{role}/#{server}/#{service}, but I'm a role-holder!")
      result = [node]
    end

    if result.length == 0
      Chef::Log.warn("Cannot find #{server}/#{service} for role #{role}")
      nil
    elsif result.length > 1
      get_lb_endpoint(server,service)
    else
      get_bind_endpoint(server, service, result[0])
    end
  end

  # return the endpoint info for all roles matching the
  # the service.  This differs from access_endpoint, as it
  # returns all the candidates, not merely the LB vip
  #
  def get_realserver_endpoints(role, server, service)
    query = "roles:#{role} AND chef_environment:#{node.chef_environment}"
    result, _, _ = Chef::Search::Query.new.search(:node, query)

    # if no query results, but role is in current runlist, use that
    result = [ node ] if result.length == 0 and node["roles"].include?(role)

    result.map { |nodeish| get_bind_endpoint(server, service, nodeish) }
  end

  # Get a specific node hash from another node by role
  #
  # In the event of a search with multiple results,
  # it returns the first match
  #
  # In the event of a search with a no matches, if the role
  # is held on the running node, then the current node hash
  # values will be returned
  #
  def get_settings_by_role(role, settings)
    if node["roles"].include?(role)
      node[settings]
    else
      query = "roles:#{role} AND chef_environment:#{node.chef_environment}"
      result, _, _ = Chef::Search::Query.new.search(:node, query)

      if result.length == 0
        nil
      else
        result[0][settings]
      end
    end
  end

  # Get a specific node hash from another node by recipe
  #
  # In the event of a search with multiple results,
  # it returns the first match
  #
  # In the event of a search with a no matches, if the role
  # is held on the running node, then the current node hash
  # values will be returned
  #
  def get_settings_by_recipe(recipe, settings)
    if node["recipes"].include?(recipe)
      node[settings]
    else
      query = "recipes:#{recipe} AND chef_environment:#{node.chef_environment}"
      result, _, _ = Chef::Search::Query.new.search(:node, query)

      if result.length == 0
        Chef::Log.warn("Can't find node with recipe #{recipe}")
        nil
      else
        result[0][settings]
      end
    end
  end

  def get_lb_endpoint(server, service)
    rcb_exit_error("LB endpoints not yet defined")
  end
end

class Chef::Recipe
  include RCB
end

class Chef::Recipe::IPManagement
  # find the local ip for a host on a specific network
  def self.get_ip_for_net(network, node)
    if network == "all"
      return "0.0.0.0"
    end

    if network == "localhost"
      return "127.0.0.1"
    end

    # remap the network if a map is present
    if node.has_key?("osops_networks") and
        node["osops_networks"].has_key?("mapping") and
        node["osops_networks"]["mapping"].has_key?(network)
      network = node["osops_networks"]["mapping"][network]
    end

    if not (node.has_key?("osops_networks") and node["osops_networks"].has_key?(network)) then
      error = "Can't find network #{network}"
      Chef::Log.error(error)
      raise error
    end

    net = IPAddr.new(node["osops_networks"][network])
    node["network"]["interfaces"].each do |interface|
      interface[1]["addresses"].each do |k,v|
        if v["family"] == "inet6" or v["family"] == "inet" then
          addr=IPAddr.new(k)
          if net.include?(addr) then
            return k
          end
        end
      end
    end

    error = "Can't find address on network #{network} for node"
    Chef::Log.error(error)
    raise error
  end

  # find the realserver ips for a particular role
  def self.get_ips_for_role(role, network, node)
    if Chef::Config[:solo] then
      return [self.get_ip_for_net(network, node)]
    else
      candidates, _, _ = Chef::Search::Query.new.search(:node, "chef_environment:#{node.chef_environment} AND roles:#{role}")
      if candidates == nil or candidates.length <= 0
        if node["roles"].include?(role)
          candidates = [node]
        end
      end

      if candidates == nil or candidates.length <= 0
        error = "Can't find any candidates for role #{role} in environment #{node.chef_environment}"
        Chef::Log.error(error)
        raise error
      end

      return candidates.map { |x| get_ip_for_net(network, x) }
    end
  end

  # find the loadbalancer ip for a particular role
  def self.get_access_ip_for_role(role, network, node)
    if Chef::Config[:solo] then
      return self.get_ip_for_net(network, node)
    else
      candidates, _, _ = Chef::Search::Query.new.search(:node, "chef_environment:#{node.chef_environment} AND roles:#{role}")
      if candidates == nil or candidates.length == 0
        if node["roles"].include?(role)
          candidates = [ node ]
        end
      end

      if candidates.length == 1 then
        return get_ip_for_net(network, candidates[0])
      elsif candidates.length == 0 then
        error = "Can't find any candidates for role #{role} in environment #{node.chef_environment}"
        Chef::Log.error(error)
        raise error
      else
        if not node["osops_networks"] or not node["osops_networks"]["vips"] or not node["osops_networks"]["vips"][role] then
          error = "Can't find lb vip for #{role} (osops_networks/vips/#{role}) in environment, with #{candidates.length} #{role} nodes"
          Chef::Log.error(error)
          raise error
        else
          return node["osops_networks"]["vips"][role]
        end
      end
    end
  end
end
