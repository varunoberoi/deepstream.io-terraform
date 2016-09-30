variable "redis_droplet_size" {}

# Create Droplet w/ Docker for Deepstream.io
resource "digitalocean_droplet" "redis" {
  image  = "redis"
  name   = "redis"
  region = "${var.region}"
  size   = "${var.redis_droplet_size}mb"

  ipv6               = true
  private_networking = true

  ssh_keys = [
    "${digitalocean_ssh_key.ssh_key.fingerprint}",
  ]
}

resource "null_resource" "redis_ip" {
  depends_on = ["digitalocean_droplet.redis"]

  connection {
    host     = "${digitalocean_droplet.redis.ipv4_address}"
    user     = "root"
    type     = "ssh"
    key_file = "${var.private_key}"
    timeout  = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/bind 127.0.0.1$/bind ${digitalocean_droplet.redis.ipv4_address_private}/g' /etc/redis/redis.conf",
      "service redis restart",
    ]
  }
}