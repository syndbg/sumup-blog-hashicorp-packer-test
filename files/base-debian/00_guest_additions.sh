#!/usr/bin/env bash
echo "Installing VirtualBox guest additions"

apt install -y linux-headers-$(uname -r) build-essential
apt install -y dkms

VBOX_VERSION=$(cat /root/.vbox_version)
mount -o loop /root/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm /root/VBoxGuestAdditions_$VBOX_VERSION.iso