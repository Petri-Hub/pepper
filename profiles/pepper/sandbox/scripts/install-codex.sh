#!/usr/bin/env bash
# Codex — OpenAI's coding agent, for when a job suits it better than Claude
# Code, signed in to Petri's ChatGPT plan rather than the API key Pepper
# already shares with GPT-6-Luna.
#
# Upstream ships two Linux downloads: a bare binary, and a package that bundles
# it with the helpers it expects beside it (its own rg, bwrap, the code-mode
# host). Only the package is listed in codex-package_SHA256SUMS, so the package
# is what is installed, and the digest is upstream's.
#
# This installs the binary. Signing in is CODEX_ACCESS_TOKEN, which arrives at
# runtime from sandbox/credentials.

source "$(dirname "$0")/lib/common.sh"

require_version CODEX_VERSION "${CODEX_VERSION:-}"

# musl is the only Linux build Codex publishes, and it is static, so it runs on
# this glibc base unchanged.
archive="codex-package-x86_64-unknown-linux-musl.tar.gz"
base="https://github.com/openai/codex/releases/download/rust-v${CODEX_VERSION}"
make_workdir
dir="$WORKDIR"

fetch "$base/$archive" "$dir/$archive"
fetch "$base/codex-package_SHA256SUMS" "$dir/SHA256SUMS"

expected="$(awk -v want="$archive" '$2 == want { print $1 }' "$dir/SHA256SUMS")"
[ -n "$expected" ] || die "$archive is not listed in upstream's codex-package_SHA256SUMS"
verify_sha256 "$dir/$archive" "$expected"

# The package finds its helpers relative to bin/codex, so it keeps its own
# tree under /opt and only the entry point goes on PATH.
rm -rf /opt/codex
mkdir -p /opt/codex
tar -xzf "$dir/$archive" -C /opt/codex
[ -x /opt/codex/bin/codex ] || die "no bin/codex inside $archive"
ln -sf /opt/codex/bin/codex /usr/local/bin/codex
log "installed /opt/codex, linked /usr/local/bin/codex"

smoke codex --version
log "$(codex --version 2>&1 | head -1) ready"
