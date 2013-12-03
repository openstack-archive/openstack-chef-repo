name "os-image-upload"
description "Glance image upload"
run_list(
  "role[os-base]",
  "recipe[openstack-image::image_upload]"
  )
