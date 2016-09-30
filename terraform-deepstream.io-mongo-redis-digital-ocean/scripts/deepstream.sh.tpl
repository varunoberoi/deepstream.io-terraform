#!/bin/bash

echo "Downloading deepstream.io"

source /etc/lsb-release && echo "deb http://dl.bintray.com/deepstreamio/deb $${DISTRIB_CODENAME} main" | sudo tee -a /etc/apt/sources.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
apt-get update

echo "Installing deepstream.io"
apt-get install -y deepstream.io

echo "Installing mongodb storage plugin"
deepstream install storage mongodb

echo "Installing redis cache plugin"
deepstream install cache redis

echo "Installing redis message plugin"
deepstream install message redis

cd /etc/deepstream/ && curl -O https://raw.githubusercontent.com/deepstreamIO/ds-demo-digital-ocean/master/config.yml -O https://raw.githubusercontent.com/deepstreamIO/ds-demo-digital-ocean/master/permissions.yml -O https://raw.githubusercontent.com/deepstreamIO/ds-demo-digital-ocean/master/users.yml

# Replace hard-coded ips
sed -i 's/10.135.16.125/${redis_private_ip}/' /etc/deepstream/config.yml
sed -i 's/10.135.22.234/${mongo_private_ip}/' /etc/deepstream/config.yml

echo "Starting deepstream.io"
deepstream start &