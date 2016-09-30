variable "mongo_droplet_size" {}

# Create Droplet w/ Docker for Deepstream.io
resource "digitalocean_droplet" "mongo" {
  image  = "mongodb"
  name   = "mongo"
  region = "${var.region}"
  size   = "${var.mongo_droplet_size}mb"

  ipv6               = true
  private_networking = true

  ssh_keys = [
    "${digitalocean_ssh_key.ssh_key.fingerprint}",
  ]
}

resource "null_resource" "mongo_ip" {
  depends_on = ["digitalocean_droplet.mongo"]

  connection {
    host     = "${digitalocean_droplet.mongo.ipv4_address}"
    user     = "root"
    type     = "ssh"
    key_file = "${var.private_key}"
    timeout  = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/bindIp: 127.0.0.1$/bindIp: ${digitalocean_droplet.mongo.ipv4_address_private}/g' /etc/mongod.conf",
      "service mongod restart",
    ]
  }
}