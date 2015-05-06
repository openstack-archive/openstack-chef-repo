# Tools

## Using the test_patch tool

The tools/test_patch.rb tool will do most of the heavy lifting of testing out one or more patches.
It will basically create a clean environment with a copy of the repo and the patched cookbook, and then run
one of the test environments.

To see the various options and help:

```shell
$ chef exec ruby tools\test_patch.rb help test
```

## Cookbook Patch Development

The Berksfile in this repo has been enhanced to look for local working cookbook development directories and use them
to when running the test suite.  Simply set REPO_DEV=True and create a directory tree as follows:

* base_dev_dir\
** openstack-chef-repo
** cookbook-openstack-***

When doing the 'chef exec rake berks_vendor', the Berks file will pick up cookbooks changes from the
cookbook-openstack-*** directories.
