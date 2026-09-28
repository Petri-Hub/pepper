#!/usr/bin/env bash
# ai-memory — the cross-session memory Pepper's coding work reads and writes.
#
# Upstream publishes a .sha256 beside each asset, so the digest is fetched
# rather than pinned here, and compose.yml carries only the version.
#
# This installs the binary. It does not connect anything: the server URL and
# whatever credential it needs have to arrive at runtime, because this image is
# public and nothing secret can be baked into a layer.

source "$(dirname "$0")/lib/common.sh"

require_version AI_MEMORY_VERSION "${AI_MEMORY_VERSION:-}"

archive="ai-memory-linux-x86_64.tar.gz"
base="https://github.com/akitaonrails/ai-memory/releases/download/v${AI_MEMORY_VERSION}"
make_workdir
dir="$WORKDIR"

fetch "$base/$archive" "$dir/$archive"
fetch "$base/$archive.sha256" "$dir/$archive.sha256"
verify_sha256 "$dir/$archive" "$(cat "$dir/$archive.sha256")"

tar -xzf "$dir/$archive" -C "$dir"
install_bin "$(find_bin "$dir" ai-memory)" ai-memory

# The hook scripts ship beside the binary, and install-hooks renders Claude
# Code's and Codex's config from them. This is the first place it looks when no
# --hooks-dir is given; OpenCode's plugin is generated and needs none of it.
[ -d "$dir/hooks" ] || die "no hooks/ bundle inside $archive"
rm -rf /usr/local/share/ai-memory/hooks
mkdir -p /usr/local/share/ai-memory
cp -r "$dir/hooks" /usr/local/share/ai-memory/hooks
log "installed hooks bundle to /usr/local/share/ai-memory/hooks"

smoke ai-memory --version
