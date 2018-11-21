#!/usr/bin/env bash
# NOTE: This file is run by packer provisioner `shell-local`.
# It's useful for active development of the test suite by making the guest sleep for a long time.

if [[ "$MUST_SLEEP_BEFORE_TESTS" != "true" ]]; then
    exit 0
fi

sleep 99999

