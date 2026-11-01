#!/bin/sh
set -eu

install -d -m 0700 /var/lib/lemon/ssh
install -d -m 0755 /run/sshd

# sshd builds a fresh environment for every session, and PAM reads only
# /etc/environment, so the container's own variables never reach a login.
# The game's tests look for their credentials there.
environment=/etc/environment
tmp=$(mktemp)
grep -v -E '^(JEST_ROBLOX_OPEN_CLOUD_API_KEY|JEST_ROBLOX_UNIVERSE_ID|JEST_ROBLOX_PLACE_ID)=' \
    "$environment" > "$tmp" 2>/dev/null || true
for name in JEST_ROBLOX_OPEN_CLOUD_API_KEY JEST_ROBLOX_UNIVERSE_ID JEST_ROBLOX_PLACE_ID; do
    value=$(printenv "$name" || true)
    if [ -n "$value" ]; then
        printf '%s=%s\n' "$name" "$value" >> "$tmp"
    fi
done
chmod 0600 "$tmp"
mv "$tmp" "$environment"

if [ ! -s /var/lib/lemon/ssh/ssh_host_ed25519_key ]; then
    ssh-keygen -q -t ed25519 -N '' -f /var/lib/lemon/ssh/ssh_host_ed25519_key
fi

exec /usr/sbin/sshd -D -e
