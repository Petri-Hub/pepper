#!/bin/sh
set -eu

# Require Modal access before preparing the workspace or starting SSH.
: "${MODAL_TOKEN_ID:?Missing Modal token ID}"
: "${MODAL_TOKEN_SECRET:?Missing Modal token secret}"

# SSH directories — persistent host key and server runtime files
install -d -m 0700 /var/lib/lemon/ssh
install -d -m 0755 /run/sshd

# Workspace — create the layout after the persistent directory is mounted
runuser -u lemon -- mkdir -p /home/lemon/workspace/scratchpad \
    /home/lemon/workspace/tools \
    /home/lemon/workspace/projects \
    /home/lemon/workspace/sessions

# Test environment — make Open Cloud settings available to SSH sessions via PAM
: "${JEST_ROBLOX_OPEN_CLOUD_API_KEY:?Missing Open Cloud API key}"
: "${JEST_ROBLOX_UNIVERSE_ID:?Missing test universe ID}"
: "${JEST_ROBLOX_PLACE_ID:?Missing test place ID}"
: "${ROBLOX_API_KEY:?Missing Roblox Assets MCP API key}"
: "${ROBLOX_OWNER_ID:?Missing Roblox Assets MCP owner ID}"
: "${ROBLOX_OWNER_TYPE:?Missing Roblox Assets MCP owner type}"
case "$ROBLOX_OWNER_ID" in *[!0-9]*) echo 'Invalid Roblox Assets MCP owner ID' >&2; exit 1;; esac
case "$ROBLOX_OWNER_ID" in *[1-9]*) ;; *) echo 'Invalid Roblox Assets MCP owner ID' >&2; exit 1;; esac
case "$ROBLOX_OWNER_TYPE" in user|group) ;; *) echo 'Invalid Roblox Assets MCP owner type' >&2; exit 1;; esac

install -m 0600 /dev/null /etc/environment
printf '%s\n' \
    "JEST_ROBLOX_OPEN_CLOUD_API_KEY=$JEST_ROBLOX_OPEN_CLOUD_API_KEY" \
    "JEST_ROBLOX_UNIVERSE_ID=$JEST_ROBLOX_UNIVERSE_ID" \
    "JEST_ROBLOX_PLACE_ID=$JEST_ROBLOX_PLACE_ID" \
    "ROBLOX_API_KEY=$ROBLOX_API_KEY" \
    "ROBLOX_OWNER_ID=$ROBLOX_OWNER_ID" \
    "ROBLOX_OWNER_TYPE=$ROBLOX_OWNER_TYPE" \
    "MODAL_TOKEN_ID=$MODAL_TOKEN_ID" \
    "MODAL_TOKEN_SECRET=$MODAL_TOKEN_SECRET" > /etc/environment

# SSH identity — reuse the persistent key or create it on first startup
if [ ! -s /var/lib/lemon/ssh/ssh_host_ed25519_key ]; then
    ssh-keygen -q -t ed25519 -N '' -f /var/lib/lemon/ssh/ssh_host_ed25519_key
fi

# SSH server — run in the foreground as the container's main process
exec /usr/sbin/sshd -D -e
