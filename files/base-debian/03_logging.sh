#!/usr/bin/env bash
mkdir -p /var/log/journal

cat <<EOF >/etc/systemd/journald.conf
[Journal]
Storage=persistent
SystemMaxUse=10%
SplitMode=none
SystemMaxFiles=100
RuntimeMaxFiles=100
EOF

systemctl daemon-reload
systemctl restart systemd-journald
