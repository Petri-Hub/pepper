#!/usr/bin/env bash
# OpenCode — the coding agent Pepper runs inside the sandbox.
#
# A single static binary from GitHub releases: no Node, no Bun, no npm install
# at runtime. That is most of why it belongs in an image at all.
#
# It is the one tool here that publishes no checksum of any kind, so the digest
# comes from compose.yml instead of from upstream. See the note there for what
# that does and does not protect against.

source "$(dirname "$0")/lib/common.sh"

require_version OPENCODE_VERSION "${OPENCODE_VERSION:-}"
[ -n "${OPENCODE_SHA256:-}" ] || die "OPENCODE_SHA256 is empty; OpenCode ships no checksum, so the pin in compose.yml is the only verification there is"

# glibc, x86_64. The musl and baseline builds exist for other bases; if
# BASE_IMAGE ever moves to Alpine or to arm64, this is the line that changes.
archive="opencode-linux-x64.tar.gz"
make_workdir
dir="$WORKDIR"

fetch "https://github.com/anomalyco/opencode/releases/download/v${OPENCODE_VERSION}/${archive}" "$dir/$archive"
verify_sha256 "$dir/$archive" "$OPENCODE_SHA256"

tar -xzf "$dir/$archive" -C "$dir"
install_bin "$(find_bin "$dir" opencode)" opencode

# --version is enough: it exercises the binary without reaching for a config
# file, a provider key or a network the build has no business needing.
smoke opencode --version
log "opencode $(opencode --version 2>&1 | head -1) ready"
