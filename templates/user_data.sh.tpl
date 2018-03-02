#!/bin/bash
set -e

apt-get -y update

DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server

apt-get -y install nginx
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash 
apt-get install -y nodejs

sudo npm i -g ghost-cli@latest

mkdir -p /var/www/ghost
chown ubuntu:ubuntu /var/www/ghost
chmod 775 /var/www/ghost

export NODE_ENV=production


sudo -u ubuntu ghost install --no-setup -d /var/www/ghost

sudo -u ubuntu ghost start --enable

echo "${ghost_config}" > /var/www/ghost/config.json 
