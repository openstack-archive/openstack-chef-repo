Just to capture the proposed style of cookbooks and code in the repository.

Cookbooks
=========
Foodcritic
----------
Foodcritic (http://acrmp.github.com/foodcritic/) is extremely useful for keeping cookbooks consistent. Please check your commits against it, documenting rationale for disregarding recommendations.

Default Recipes
---------------
There should be no default recipes with the OpenStack cookbooks. This recommendation is because there are so many potential ways to deploy this, we should be explicit in defining what we mean. For example, should the default for Keystone be as a client of keystone or a server?

include_recipe
--------------
With the modular approach we're taking, include_recipe should probably be used sparingly. Explicit inclusion of the recipes we want to use should be used in roles instead.

Testing
=======
