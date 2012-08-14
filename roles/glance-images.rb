name "glance-images"
description "Define the images you're going to use with OpenStack."

override_attributes(
  "glance" => {
    "image_upload" => true,
    "images" => ["precise"],
    "image" => {
      "precise" => "http://hypnotoad/precise-server-cloudimg-amd64.tar.gz"
    }
  }
  )
