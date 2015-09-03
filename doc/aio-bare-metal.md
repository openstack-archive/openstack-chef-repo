# OpenStack On Bare-Metal

This is the process to install OpenStack via Chef and the recipes to complete an OpenStack All in One build.  We will leverage Chef to give the ability to standup an OpenStack Kilo environment.

## Terms

- **OpenStack** or **OpenStack server** = The physical machine that only has Ubuntu running on it
- **Workstation** = This is the machine or VM that has the ChefDK installed.  This will be the system that communicates to the Chef server
- **Chef Server** = This is either the Hosted Chef solution or can be in On Premises Chef server

## Prereqs

- [ChefDK](https://downloads.chef.io/chef-dk/) 0.7.0 or later
- [Ubuntu](http://www.ubuntu.com/download/server) 14.04 or later
- You will need to have 2 NICs on the OpenStack Server.  Your configuration should look similar to this:

```
auto eth0
iface eth0 inet static
        address 192.168.2.5
        gateway 192.168.2.254
        dns-nameservers 192.168.2.254
        netmask 255.255.255.0
auto eth1
iface eth1 inet manual
```

Where `eth0` is a management network, and `eth1` is a bridged connected NIC to your network.

## Initial Setup Steps

### Installing ChefDK on the Workstation

- If not already installed install git (`apt-get install git`)
- If not already installed install unzip (`apt-get install unzip`)
- [ChefDK Installation Instructions](https://docs.chef.io/install_dk.html)

### Setup the Chef Server

- [Chef Server install](https://docs.chef.io/install_server.html) This can be a standalone server or an HA environment.  For the purpose of this i would recommend an standalone server at first
- [Hosted Chef Setup](https://learn.chef.io/manage-a-node/rhel/set-up-your-chef-server/#step1) This will walk you through the ability to create a free hosted Chef Server

### Setting up the workstation

Create a local copy repo of the OpenStack Chef Repo.

- `git clone https://github.com/OpenStack/OpenStack-chef-repo.git`
- `git checkout stable/kilo # if you would like to run newest stable release`

Login to the Chef Server Website

 - Create an Organization (Under the Administration Tab)
   - Type the Full name and the short-name
   - Click the `Create Organization`
 - Click `Download the starter kit`
   - You will be prompted with "Your user and organization keys will be reset. Are you sure you want to do this?"
    - Click `Proceed`
 - Copy this file to the Workstation folder you will be working out of

Extracting the Starter Kit on the Workstation

- verify that you are in the location on the workstation where the start-kit.zip file is located

```
$ unzip starter-kit.zip
$ cd chef-repo/.chef
```

Verify the connection from the workstation to the Chef Server

```
$ chef exec knife status
```

If everything works correctly you will not receive any errors

Copy the extracted repo to the cloned repo from earlier.

```
$  cp -R ../.chef ../ ../../
```

#### Create a new Branch

The path you should now want to be at is in the cloned repo.

```
$ git checkout -b <name_you_would_like_to_have>
```
then run `git status` and this should result in an error

```
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

  modified:   .chef/knife.rb
  modified:   .gitignore
  modified:   README.md

Untracked files:
  (use "git add <file>..." to include in what will be committed)

  cookbooks/
  roles/starter.rb

no changes added to commit (use "git add" and/or "git commit -a")
```

#### Setting up the Local OpenStack Repo

##### Berks

- Install the Berks
 `chef exec berks install`
- Upload the Berks
 `chef exec berks upload`

##### Setting up the AIO Neutron json

Download a template json for OpenStack

[Click here to see the example json](../environments/baremetal-aio-neutron.json)

Modify the json for the environment to point to the file that you are using

###### Modifying the JSON File

- Change the apache "listen_addresses" to your external IP for OpenStack
- Change the endpoints "bind-hosts"", and "host" to your external IP for OpenStack
- Verify that your network interface is eth0 and eth1.  If not modify this file and change eth0 for en0 or whatever the NIC is named.  Same would go for eth1.  (ONLY NEEDED if NIC NAME IS DIFFERENT)
- Save the file once completed

##### Uploading Roles

Now it is time to upload the roles.  From within the roles folder

```
chef exec knife role from file *
```
##### Changing and Uploading Passwords

This is one of the critical points.  This is the stage where you can modify the passwords that OpenStack will use.  You must be careful and run all of the listed commands in this article in order for it to work correctly.

[How to modify the Data Bags Passwords](https://github.com/OpenStack/OpenStack-chef-repo/blob/master/doc/databags.md)

To create the Data Bags go to the OpenStack-chef-repo/data_bags folder. The following commands will create the Data Bags and then Upload the Data Bag on the Chef Server

```
cd ../data_bags/db_passwords/
chef exec knife data bag create db_passwords
chef exec knife data bag from file db_passwords ./
cd ../secrets
chef exec knife data bag create secrets
chef exec knife data bag from file secrets ./
cd ../service_passwords
chef exec knife data bag create service_passwords
chef exec knife data bag from file service_passwords ./
cd ../user_passwords
chef exec knife data bag create user_passwords
chef exec knife data bag from file  user_passwords ./
chef exec knife upload /environments
```

### Setting up the OpenStack Server

#### Verify connectivity

- Once the Operating system is on the machine verify sshd is up and running on the server.
- Also verify the Server is able to access the Chef Server and the Chef Workstation is able to access the OpenStack Server

#### Bootstrap the OpenStack Server to the Chef Environment

On the Chef Workstation run the following

```
chef exec knife bootstrap <IP> -x <user> -P <password> -N <nodename> --sudo
```
If you receive any errors please address these before proceeding

Then add the runlist for the OpenStack Server

```
chef exec knife node run_list add  <nodename> 'role[allinone-compute], role[os-image-upload], role[os-orchestration], role[os-block-storage]'
```

Now we will need to modify the node to point to the OpenStack environment.

```
chef exec knife node edit <nodename>
```

It should look like

```
{
  "name": "nodename",
  "chef_environment": "File name that was created earlier <Orgname>-aio.neutron.json>",
  "normal": {
    "tags": [

    ]
  },
  "run_list": [
  "role[allinone-compute]",
  "role[os-image-upload]",
  "role[os-orchestration]",
  "role[os-block-storage]"
]

}

```

We will need to copy the encrypted_data_bag_secret to the OpenStack server.

```
scp encrypted_data_bag_secret <user>@<nodename>:
```
Then we will move the file from the home locate to the correct location on the OpenStack server

```
mv encrypted_data_bag_secret /etc/chef/OpenStack_data_bag_secret
```
We now are going to make a temporary change this section can be removed after the install but would be recommended to keep in place for future needs.

Create a file in `/etc/apt/apt.conf.d/90forceyes` with the following content:

```
APT::Get::Assume-Yes "true";
APT::Get::force-yes "true";
```

## Creating OpenStack from Chef Repo

Now you should be able to login to the OpenStack Server and run as root:

```
chef-client
```

You may have to modify the `/etc/apache2/ports.conf` to point to the external IP address vs the internal

# Login to your OpenStack Environment!!

## Setup the networking for OpenStack

On the OpenStack server login

Source the file so we will be able to access the OpenStack api. Then we will run `nova image-list` to see the current images that were built by OpenStack.

```
# source openrc
# nova image-list
+--------------------------------------+---------------+--------+--------+
| ID                                   | Name          | Status | Server |
+--------------------------------------+---------------+--------+--------+
| 8dfa3a8f-a982-4197-b8f7-5116e33d56fb | centos-7      | ACTIVE |        |
| 332d52fb-d080-41bc-b8cf-48460baae60a | cirros        | ACTIVE |        |
| ea18acb2-18f5-432b-b8c7-40fdecf2d87b | ubuntu-trusty | ACTIVE |        |
+--------------------------------------+---------------+--------+--------+
```

Now we want to look at the current networking:

```
# ovs-vsctl show
f816c29f-27f8-4a0d-8e82-9ee0313f6c16
    Bridge br-ex
        Port "eth1"
            Interface "eth1"
        Port br-ex
            Interface br-ex
                type: internal
    Bridge br-tun
        Port br-tun
            Interface br-tun
                type: internal
    Bridge br-int
        fail_mode: secure
        Port br-int
            Interface br-int
                type: internal
   ovs_version: "2.3.1"
```

Now create the flat network:

```
# neutron net-create ext-net --router:external --provider:physical_network external --provider:network_type flat
Created a new network:
+---------------------------+--------------------------------------+
| Field                     | Value                                |
+---------------------------+--------------------------------------+
| admin_state_up            | True                                 |
| id                        | 7276586e-10e1-462d-a9c2-a35f99a7b53d |
| mtu                       | 0                                    |
| name                      | ext-net                              |
| provider:network_type     | flat                                 |
| provider:physical_network | external                             |
| provider:segmentation_id  |                                      |
| router:external           | True                                 |
| shared                    | False                                |
| status                    | ACTIVE                               |
| subnets                   |                                      |
| tenant_id                 | 57443e433b6744d3a36227717032515e     |
+---------------------------+--------------------------------------+
```

Create the external IP range

```
neutron subnet-create ext-net  <EXTERNAL_IP_SUBNET i.e. 192.168.1.1/24> --name ext-subnet --allocation-pool start=<START_EXTERNAL_IP_RANGE>,end=<ENDING_EXTERNAL_IP_RANGE> --disable-dhcp --gateway <GATEWAY_IP>
```

```
# neutron subnet-create ext-net  192.168.2.0/24 --name ext-subnet --allocation-pool start=192.168.2.200,end=192.168.2.240 --disable-dhcp --gateway 192.168.2.254
Created a new subnet:
+-------------------+----------------------------------------------------+
| Field             | Value                                              |
+-------------------+----------------------------------------------------+
| allocation_pools  | {"start": "192.168.2.200", "end": "192.168.2.240"} |
| cidr              | 192.168.2.0/24                                     |
| dns_nameservers   |                                                    |
| enable_dhcp       | False                                              |
| gateway_ip        | 192.168.2.254                                      |
| host_routes       |                                                    |
| id                | 1a4d8f0f-44c2-4e6d-bd68-019eedf13af9               |
| ip_version        | 4                                                  |
| ipv6_address_mode |                                                    |
| ipv6_ra_mode      |                                                    |
| name              | ext-subnet                                         |
| network_id        | 7276586e-10e1-462d-a9c2-a35f99a7b53d               |
| subnetpool_id     |                                                    |
| tenant_id         | 57443e433b6744d3a36227717032515e                   |
+-------------------+----------------------------------------------------+
```

Now access the OpenStack Server WebUI
Login to the webui:  https://<OpenStack ServerIP>

```
Username: Admin
Password: <Whatever was set earlier>
```
Then Login

### Create Router for First Network

1. Expand the `Project` tab in the top left hand side of the screen.
1. Choose the drop down for `Network`.  Once you see a link for `Routers` choose that one.
1. In the top right hand side of the `Routers` page click `Create Router`.  this will bring up a pop up windows with the Title of `Create Router`
1. Now for the `Router Name` you can enter whichever name you prefer
1. Leave the `Admin State` on `Up`
1. For the `External Network` use the drop down to ext-net unless you modified the script from earlier.
1. Then click on the button labeled `Create Router`
1. You should see a Green box in the top right hand corner of the page saying `Successful`.  Also the name of the router you created and status should also say `Active`

### Create Internal Network

1. With in the `Network` section click on `Network Topology` on the left hand side of the screen.
1. In the top right hand corner click on the `+ Create Network` button
1. A window will open with the title of `Create Network`
1. In the `Network Name` field enter the name you would like.  For this example we chose adminint-net.  Since we are under the Admin project.  You will have to create a network for each project that you want.
1. For the `Admin State` Leave the setting as `UP`
1. Choose next for the `Subnet` Section.
1. You can name this `Subnet Name` anything you would like.  We used adminsubnet.
1. For the `Network Address` field this will be the subnet that is the internal network for this network.  We used `172.16.1.0/24`
1. You can leave the `IP Version` as IPV4 and the `Gateway IP` empty.
1. Leave the `Disable Gateway` unchecked.
1. Choose `Next` to move to the `Subnet Details` section
1. For the `Subnet Details` section you can manually add the DNS servers if you desire.
1. Choose `Create` to complete the internal networking.
1. You should see a Green box in the top right hand corner of the page saying `Successful`.

### Create the additional interface for the Router to connect the networks

You should now see one Blue line with the name of the external network.  The second like a orange color you have the name of the internal name and a black box in between these two with the router name.
If you highlight over the router name you will see a button that says `Add Interface` and click that button.
The title of the page will be `Add Interface` and for the `Subnet` drop down choose the internal network you created in the last section.
Leave the `IP Address`, `Router Name` and the `Router ID` alone.
Click the button labeled `Add Interface`.
You should see a Green box in the top right hand corner of the page saying `Successful`.

### Verify the Router Connectivity

Click on the router that you created in the last step.
In the `External Fixed IPs` Under the `External Gateway` Section you will see an `IP Address`.  this is the Gateway that the Virtual Machines will be accessing.
On the Chef Server see if you are able to ping that address:

```
$ ping 192.168.2.10
PING 192.168.2.10 (192.168.2.10): 56 data bytes
64 bytes from 192.168.2.10: icmp_seq=0 ttl=255 time=157.467 ms
64 bytes from 192.168.2.10: icmp_seq=1 ttl=255 time=2.147 ms
```
## Create the first OpenStack VM

Click the`Project` section on the top right hand side of the page.
Click on the `Compute` icon on the right hand side of the page under `Project`
You will now see an item with the name of `Instances` under that.  Choose that item.
On the far right hand side click the button with a cloud pointing up and the words `Launch Instance`
This will bring up a new window labeled `Launch Instance`
Type in the name of the Instance you would like to create.
For the Flavor choose which size?  keep in mind that different sizes have different disk,cpu, and memory configurations.  If you want more of a custom size you will need to do this prior to this section.
If you would like to create more than one instance this time you can choose that as well.
The `Instance Boot Source` will be which template you want to create.  For the first one i would recommend using `Boot from image` and the `Image Name` would be `cirros (9.3 MB)`.
then click on the `Networking*` tab.
Here you will click on the internal network under `Available networks` hit the `+` sign next to the internal network name.
This will add the network for the instance on the internal network.  Which in turn has a connection to the outside world via the router we created earlier.
Now choose the `Launch` button to start up the first OpenStack Instance in your new environment.
The page should turn and you will see the new instance you created.  It will have under `Task` Spawning till it complete.  the larger the operating system disk size the longer this process may take.

## Logging into the new instance

Now you will be able to click on the instance that was created in the prior section, after verifying that the Status is `Active`
If you would like to have this machine accessible from the outside in you can choose the drop down on the far right hand side instead of `Create Snapshot` Choose `Associate Floating IP`.
This will give you the abiility to choose an ip that can be accessed on the network.
Once the floating IP has been assigned you will see an IP under the `IP Address` and then another IP under the same section for `Floating IPs:`
Now click on the Instance name so we can access the console.
Then choose the tab `Console` to see the Instance's console.
You can either click on the right or left hand side in the grey area or choose the link at the top of the page labeled `Click here to show only console`.
Now that you see the console you will see that cirros gives you the username and password for this machine.  Use these credentials to login.

Now that you are logged into the Instance let verify network connectivity.
first see if you can `ping 8.8.8.8`
If that works see if DNS works and see if you can ping google.com.
If this is not working please look at the Networking topology to see where the issue may occur.  Keep in mind that the OpenStack server must have 2 NIC's that are connected to the network and have the ability to access outside resources.

#If these are working you are done!  Enjoy OpenStack brought to you by the builders at Chef
