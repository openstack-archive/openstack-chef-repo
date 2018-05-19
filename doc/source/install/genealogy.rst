=========
Genealogy
=========

- `Releases Summary`_
- `Supermarket Releases`_
- `How to release Chef cookbooks`_

Releases Summary
================

+----------------------------+------------------------------+------------------------+
| Module Version             | OpenStack Version Codename   | Community Supported    |
+============================+==============================+========================+
| 7.y.z                      | Grizzly                      | no - EOL (2014-03-29)  |
+----------------------------+------------------------------+------------------------+
| 8.y.z                      | Havana                       | no - EOL (2014-09-30)  |
+----------------------------+------------------------------+------------------------+
| 9.y.z                      | Icehouse                     | no - EOL (2015-07-02)  |
+----------------------------+------------------------------+------------------------+
| 10.z.y                     | Juno                         | no - EOL (2015-12-07)  |
+----------------------------+------------------------------+------------------------+
| 11.z.y                     | Kilo                         | no - EOL (2016-05-02)  |
+----------------------------+------------------------------+------------------------+
| 12.z.y                     | Liberty                      | no - EOL (2016-11-17)  |
+----------------------------+------------------------------+------------------------+
| 13.z.y                     | Mitaka                       | no - EOL (2017-04-10)  |
+----------------------------+------------------------------+------------------------+
| 14.z.y                     | Newton                       | yes - EOL (2017-10-11) |
+----------------------------+------------------------------+------------------------+
| 15.z.y                     | Ocata                        | yes - EOL (2017-02-26) |
+----------------------------+------------------------------+------------------------+
| 16.z.y                     | Pike                         | yes                    |
+----------------------------+------------------------------+------------------------+
| 17.z.y                     | Queens                       | yes (current master)   |
+----------------------------+------------------------------+------------------------+
| 18.z.y                     | Rocky                        | Future                 |
+----------------------------+------------------------------+------------------------+

Supermarket releases
====================

- From Ocata, the cookbooks are released on the Chef Supermarket_.

.. _Supermarket: https://supermarket.chef.io/openstack

How to release Chef cookbooks
=============================

- A core member will create the new branch based on the desired SHA.
  Example: https://review.openstack.org/#/admin/projects/openstack/cookbook-openstack-compute,branches
- For all cookbooks to be released: update .gitreview, Berksfile,
  and bootstrap.sh to stable/<release>
  Example: https://review.openstack.org/547505
- Create a review with the above and propose it against the stable/<release> branch.
- Solicit for reviews and approval.
