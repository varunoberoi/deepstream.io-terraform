variable "do_token" {}

variable "public_key" {}

variable "private_key" {}

variable "region" {}

# Configure the Digital Ocean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "ssh_key" {
  name       = "public-ssh-key"
  public_key = "${var.public_key}"
}
