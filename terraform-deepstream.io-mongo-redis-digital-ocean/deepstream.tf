variable "ds_droplet_size" {}

data "template_file" "deepstream" {
  template = "${file("scripts/deepstream.sh.tpl")}"

  vars {
    redis_private_ip = "${digitalocean_droplet.redis.ipv4_address_private}"
    mongo_private_ip = "${digitalocean_droplet.mongo.ipv4_address_private}"
  }
}

# Create Droplet w/ Docker for Deepstream.io
resource "digitalocean_droplet" "deepstream" {
  depends_on = [
    "null_resource.redis_ip",
    "null_resource.mongo_ip",
  ]

  image  = "ubuntu-14-04-x64"
  name   = "deepstream.io"
  region = "${var.region}"
  size   = "${var.ds_droplet_size}mb"

  ipv6               = true
  private_networking = true

  ssh_keys = [
    "${digitalocean_ssh_key.ssh_key.fingerprint}",
  ]

  user_data = "${data.template_file.deepstream.rendered}"
}