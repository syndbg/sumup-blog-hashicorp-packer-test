#!/usr/bin/env bash

DISK_USAGE_BEFORE_CLEANUP=$(df -h)

echo "Removing unused apt packages and leftovers"
apt -y autoremove --purge
apt -y clean
apt -y autoclean

echo "Removing /tmp/*"
rm -rf /tmp/*

echo "Removing dhcp leases"
rm -rf /var/lib/dhcp/* || true

echo "Removing logs"
find /var/log -type f | while read f; do echo -ne '' > ${f}; done;

echo "Removing last login information"
>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp

echo "Removing bash history"
unset HISTFILE
rm ~/.bash_history

echo "Zeroing-out the free space"
dd if=/dev/zero of=/EMPTY bs=1M  || echo "dd exit code $? is suppressed"
rm -f /EMPTY

# NOTE: Packer does not sync before shutdown
sync

echo "Disk usage before cleanup"
echo "${DISK_USAGE_BEFORE_CLEANUP}"

echo "Disk usage after cleanup"
df -h
