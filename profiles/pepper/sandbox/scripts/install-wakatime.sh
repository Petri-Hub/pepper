#!/usr/bin/env bash
# wakatime-cli — the heartbeats that reach Wakapi in the lab, so time spent
# working inside a sandbox shows up beside everything else.
#
# Upstream publishes one checksums_sha256.txt covering every asset, so the
# digest is fetched and the line for our archive is picked out of it.
#
# As with ai-memory, this installs the binary only. ~/.wakatime.cfg carries the
# API key and the server URL, and it has to arrive at runtime — a key in a
# public image layer is a leaked key.

source "$(dirname "$0")/lib/common.sh"

require_version WAKATIME_VERSION "${WAKATIME_VERSION:-}"

archive="wakatime-cli-linux-amd64.zip"
base="https://github.com/wakatime/wakatime-cli/releases/download/v${WAKATIME_VERSION}"
make_workdir
dir="$WORKDIR"

fetch "$base/$archive" "$dir/$archive"
fetch "$base/checksums_sha256.txt" "$dir/checksums_sha256.txt"

# The file lists every platform; take the line for ours and fail if it is absent
# rather than verifying against an empty string.
expected="$(awk -v want="$archive" '$2 == want { print $1 }' "$dir/checksums_sha256.txt")"
[ -n "$expected" ] || die "$archive is not listed in upstream's checksums_sha256.txt"
verify_sha256 "$dir/$archive" "$expected"

unzip -q "$dir/$archive" -d "$dir/unpacked"
# Upstream names the binary after its platform; install it under the plain name
# every editor plugin and every wakatime config expects to call.
install_bin "$(find_bin "$dir/unpacked" wakatime-cli-linux-amd64)" wakatime-cli

smoke wakatime-cli --version
