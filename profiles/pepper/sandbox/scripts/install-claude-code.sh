#!/usr/bin/env bash
# Claude Code — the coding agent Pepper hands work to, signed in to Petri's
# Claude subscription instead of billed to an API key.
#
# The native build, fetched the way Anthropic's own install.sh fetches it: one
# binary per platform under downloads.claude.ai, and a manifest.json beside it
# carrying each binary's SHA-256. So only the version is pinned here, as with
# ai-memory, and the digest comes from upstream.
#
# This installs the binary. Signing in is CLAUDE_CODE_OAUTH_TOKEN, which
# arrives at runtime from sandbox/credentials — a token in a public layer is a
# leaked subscription.

source "$(dirname "$0")/lib/common.sh"

require_version CLAUDE_CODE_VERSION "${CLAUDE_CODE_VERSION:-}"

# glibc, x86_64 — install.sh picks linux-x64-musl only on Alpine-like bases.
platform="linux-x64"
base="https://downloads.claude.ai/claude-code-releases/${CLAUDE_CODE_VERSION}"
make_workdir
dir="$WORKDIR"

fetch "$base/manifest.json" "$dir/manifest.json"
expected="$(jq -r --arg p "$platform" '.platforms[$p].checksum // empty' "$dir/manifest.json")"
[ -n "$expected" ] || die "no $platform entry in Claude Code's manifest for $CLAUDE_CODE_VERSION"

fetch "$base/$platform/claude" "$dir/claude"
verify_sha256 "$dir/claude" "$expected"
install_bin "$dir/claude" claude

smoke claude --version
log "claude $(claude --version 2>&1 | head -1) ready"
