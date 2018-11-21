#!/usr/bin/env bash
# NOTE: This file is run by packer provisioner `shell-local`.
# Tests on developer machines are run inside `serverspec` dir using `bundle exec rspec`.

# Arguments:
# $1 = file path to the image-specific spec to run inside serverspec dir
set -ex

if [[ "$MUST_RUN_TESTS" != "true" ]]; then
    exit 0
fi

LOG="packer.log"

ip_and_port="$(grep -F 'SSH handshake err: ssh: handshake failed: read tcp' "$LOG" \
    | pcregrep -o1 '\->([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:[0-9]{1,5})' \
    | sort \
    | uniq \
    | head)"

if [[ "$ip_and_port" == "" ]]; then
    port="$(grep -F 'Found port for communicator (SSH, WinRM, etc): ' "$LOG" \
        | pcregrep -o1 'Found\s+port\s+for\s+communicator\s+.+:\s+([0-9]{1,5})' \
        | sort \
        | uniq \
        | head)"

    if [[ "$port" == "" ]]; then
        port="$(grep -F 'Creating forwarded port mapping for communicator (SSH, WinRM, etc) ' "$LOG" \
            | pcregrep -o1 'Creating\s+forwarded\s+port\s+mapping.+\s+([0-9]{1,5})' \
            | sort \
            | uniq \
            | head)"
    fi
    # NOTE: Packer uses localhost almost always.
    # parse host from log message `Using ssh communicator to connect: ` only if needed.
    ip_and_port="127.0.0.1:$port"
fi

echo "Found IP and port in $LOG: $ip_and_port"

export TARGET_HOST=$(echo $ip_and_port | cut -d ":" -f1)
export TARGET_PORT=$(echo $ip_and_port | cut -d ":" -f2)

echo "Going to use host: $TARGET_HOST"
echo "Going to use port: $TARGET_PORT"
echo "Going to use user: $TARGET_USER"

cd ./serverspec && bundle exec rspec $1
