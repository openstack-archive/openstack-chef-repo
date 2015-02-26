# Testing the Openstack Cookbook Repo #

This cookbook uses [bundler](http://gembundler.com/) and [berkshelf](http://berkshelf.com/) to isolate dependencies. Make sure you have `ruby 1.9.x`, `bundler`, build essentials and the header files for `gecode` installed before continuing. Make sure that you're using gecode version 3. More info [here](https://github.com/opscode/dep-selector-libgecode/tree/0bad63fea305ede624c58506423ced697dd2545e#using-a-system-gecode-instead).

## Bundle required gems ##

Berkshelf 3.x needs the to use the system gecode 3.x libraries

For ubuntu 12.04 use:

 $ sudo apt-get update
 $ sudo apt-get install -y libgecode-dev libxml2-dev libxml2 libxslt-dev build-essential
 $ USE_SYSTEM_GECODE=1 bundle install --path=.bundle --jobs 1 --retry 3 --verbose

For other platforms use:

 $ bundle install --path=.bundle --jobs 1 --retry 3 --verbose

## Vendor the Cookbooks ##

 $ bundle exec berks vendor .cookbooks

## Run the Spiceweasel test ##
 
 $ bundle exec spiceweasel infrastructure.yml --debug
