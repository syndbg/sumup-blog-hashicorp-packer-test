#!/usr/bin/env bash
echo "Configure SSH keys"
apt update
apt install -y wget

wget http://${PACKER_HTTP_ADDR}/root_rsa.pub -O /tmp/root_rsa.pub
cat /tmp/root_rsa.pub >> /root/.ssh/authorized_keys
wget http://${PACKER_HTTP_ADDR}/users_rsa.pub -O /tmp/users_rsa.pub
cat /tmp/users_rsa.pub >> /root/.ssh/authorized_keys
