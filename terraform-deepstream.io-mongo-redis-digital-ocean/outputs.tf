output "details" {
  value = <<DETAILS
Deepstream:
  ssh root@${digitalocean_droplet.deepstream.ipv4_address}

Connect your client to:
    ${digitalocean_droplet.deepstream.ipv4_address}:6020

Redis:
  ssh root@${digitalocean_droplet.redis.ipv4_address}

MongoDB:
  ssh root@${digitalocean_droplet.mongo.ipv4_address}

DETAILS
}
