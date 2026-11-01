#!/bin/sh
set -eu

install -d -m 0700 /var/lib/lemon/ssh
install -d -m 0755 /run/sshd

if [ ! -s /var/lib/lemon/ssh/ssh_host_ed25519_key ]; then
    ssh-keygen -q -t ed25519 -N '' -f /var/lib/lemon/ssh/ssh_host_ed25519_key
fi

exec /usr/sbin/sshd -D -e
