#!/usr/bin/env bash
# Shared helpers for the install scripts. Sourced, never run on its own.
#
# Every script beside this one keeps the same four promises, and these helpers
# are what make keeping them cheap:
#
#   pinned      the version arrives as a build argument, never resolved as "latest"
#   verified    a checksum is always checked; where upstream publishes none, the
#               pin in compose.yml is used, and its absence is an error
#   idempotent  running twice leaves the same image
#   proven      the script runs the tool before it returns, so a bad release
#               fails the build here instead of failing Pepper mid-turn

set -euo pipefail

log() { printf '  %s\n' "$*" >&2; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

# require_version NAME VALUE — a missing pin is a build failure, not a default.
require_version() {
  local name="$1" value="${2:-}"
  [ -n "$value" ] || die "$name is empty; pin it in compose.yml and build with docker compose build"
  case "$value" in
    v*) die "$name should not carry a leading v (got $value); the scripts add it where a tag needs one" ;;
  esac
}

# fetch URL DEST — fail loudly on a 404 instead of saving GitHub's error page
# and unpacking it three lines later.
fetch() {
  local url="$1" dest="$2"
  log "fetching ${url##*/}"
  curl --fail --location --silent --show-error --retry 3 --retry-delay 2 \
    --output "$dest" "$url" || die "could not download $url"
}

# verify_sha256 FILE EXPECTED — EXPECTED may be a bare digest or a whole
# sha256sum line, since some projects publish one and some the other.
verify_sha256() {
  local file="$1" expected="${2%% *}" actual
  [ -n "$expected" ] || die "no expected digest for ${file##*/}; refusing to install unverified"
  actual="$(sha256sum "$file" | cut -d' ' -f1)"
  [ "$actual" = "$expected" ] || die "checksum mismatch for ${file##*/}: expected $expected, got $actual"
  log "checksum ok"
}

# install_bin SRC NAME — one place deciding where binaries go and who owns them.
install_bin() {
  local src="$1" name="$2"
  install -o root -g root -m 0755 "$src" "/usr/local/bin/$name"
  log "installed /usr/local/bin/$name"
}

# find_bin DIR NAME — locate the executable inside an unpacked archive, whether
# upstream ships it at the root or under a versioned directory.
find_bin() {
  local dir="$1" name="$2" found
  found="$(find "$dir" -type f -name "$name" -print -quit 2>/dev/null)"
  [ -n "$found" ] || die "no $name executable inside the archive"
  printf '%s\n' "$found"
}

# smoke NAME ARGS... — prove it runs in this image, now.
smoke() {
  local name="$1"; shift
  command -v "$name" >/dev/null || die "$name is not on PATH after install"
  "$name" "$@" >/dev/null 2>&1 || die "$name is installed but will not run"
  log "$name runs"
}

# make_workdir — scratch that removes itself, so no layer keeps a 58 MB tarball.
# Sets WORKDIR instead of printing it: called as dir="$(…)", the trap would
# belong to the command substitution's subshell and delete the directory the
# moment that subshell exited, before the caller ever wrote to it.
make_workdir() {
  WORKDIR="$(mktemp -d)"
  # shellcheck disable=SC2064  # expand WORKDIR now, not when the trap fires
  trap "rm -rf '$WORKDIR'" EXIT
}
