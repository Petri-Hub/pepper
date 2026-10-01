#!/usr/bin/env bash
# What the hyperframes and brag skills need to render a video: Node 22, FFmpeg,
# the HyperFrames CLI and the headless Chrome it captures frames with.
#
# The base image ships Node 20 and HyperFrames refuses anything older than 22,
# so Node is replaced here, from nodejs.org, checked against the SHASUMS256.txt
# published beside the tarball. FFmpeg and Chrome's system libraries come from
# Debian like the rest of install-core.sh, unpinned by hand. The HyperFrames CLI
# and the Chrome build Puppeteer pairs with are pinned in compose.yml, because
# the skill's own setup.sh would otherwise resolve "latest" on every fresh
# sandbox and download Chrome again each time.

source "$(dirname "$0")/lib/common.sh"

require_version NODE_VERSION "${NODE_VERSION:-}"
require_version HYPERFRAMES_VERSION "${HYPERFRAMES_VERSION:-}"
require_version PUPPETEER_VERSION "${PUPPETEER_VERSION:-}"

log "installing system packages"
apt-get update -qq
apt-get install -y --no-install-recommends -qq \
  ffmpeg \
  xz-utils \
  fonts-liberation \
  libasound2t64 \
  libatk-bridge2.0-0t64 \
  libatk1.0-0t64 \
  libcairo2 \
  libcups2t64 \
  libdbus-1-3 \
  libdrm2 \
  libgbm1 \
  libnspr4 \
  libnss3 \
  libpango-1.0-0 \
  libx11-6 \
  libxcb1 \
  libxcomposite1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxkbcommon0 \
  libxrandr2
rm -rf /var/lib/apt/lists/*

# Modal runs this image on x86_64.
archive="node-v${NODE_VERSION}-linux-x64.tar.xz"
base="https://nodejs.org/dist/v${NODE_VERSION}"
make_workdir
dir="$WORKDIR"

fetch "$base/$archive" "$dir/$archive"
fetch "$base/SHASUMS256.txt" "$dir/SHASUMS256.txt"
expected="$(awk -v want="$archive" '$2 == want { print $1 }' "$dir/SHASUMS256.txt")"
[ -n "$expected" ] || die "$archive is not listed in upstream's SHASUMS256.txt"
verify_sha256 "$dir/$archive" "$expected"

# The base image's Node 20 lives in /usr/local too. It is removed first, npm
# included: unpacking over it leaves old npm modules mixed with new ones, and
# npm then dies on load with "Class extends value undefined".
rm -rf /usr/local/lib/node_modules /usr/local/include/node \
  /usr/local/bin/node /usr/local/bin/npm /usr/local/bin/npx /usr/local/bin/corepack
tar -xJf "$dir/$archive" -C /usr/local --strip-components=1 --no-same-owner
[ "$(node --version)" = "v${NODE_VERSION}" ] || die "node is $(node --version), expected v${NODE_VERSION}"
log "node $(node --version), npm $(npm --version)"

log "installing the hyperframes CLI"
npm install -g --no-audit --no-fund "hyperframes@${HYPERFRAMES_VERSION}"

# Where `npx puppeteer browsers install` puts it by default, and where the
# engine looks. Pinning the Puppeteer release pins the Chrome build it pairs with.
log "caching chrome-headless-shell"
npx --yes "puppeteer@${PUPPETEER_VERSION}" browsers install chrome-headless-shell
npm cache clean --force >/dev/null 2>&1

smoke node --version
smoke ffmpeg -version
smoke hyperframes --version
hyperframes doctor || die "hyperframes doctor reported problems"
log "video tooling ready"
