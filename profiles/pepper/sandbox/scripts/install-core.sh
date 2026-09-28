#!/usr/bin/env bash
# The floor every other script and every skill stands on: the system packages a
# sandbox needs to be worth working in, and the Python libraries that otherwise
# fail Pepper's first Gmail or GitHub call of the session.
#
# Nothing here is pinned to a version by hand. Debian's packages come from the
# base image's own suite, and the Python side is pinned in requirements-core.txt
# where the reasons for each pin are written down.

source "$(dirname "$0")/lib/common.sh"

log "installing system packages"
apt-get update -qq
apt-get install -y --no-install-recommends -qq \
  ca-certificates \
  curl \
  git \
  jq \
  less \
  ripgrep \
  unzip
# Not installed, on purpose: the gh CLI. SOUL.md is explicit that it "is not
# installed here and never will be", and tells her to ignore any instruction to
# run gh auth login — she authenticates as her GitHub App through the
# github-app-auth skill, minting a token per task. Putting gh in this image
# would hand her a second, worse path to GitHub and quietly contradict her
# own rules. Leave it out.
rm -rf /var/lib/apt/lists/*
log "system packages installed"

# Debian marks its Python as externally managed on some bases and not others.
# Detect rather than guess, so this script works on either without a flag that
# is wrong half the time.
pip_flags=(--no-cache-dir --root-user-action=ignore)
if [ -e "$(python3 -c 'import sysconfig; print(sysconfig.get_path("stdlib"))')/EXTERNALLY-MANAGED" ]; then
  log "python is externally managed; installing into system site-packages anyway"
  pip_flags+=(--break-system-packages)
fi

log "installing python libraries"
python3 -m pip install "${pip_flags[@]}" --upgrade pip
python3 -m pip install "${pip_flags[@]}" -r "$(dirname "$0")/requirements-core.txt"

# Import rather than trust pip's exit code: a wheel can install and still fail
# to load against this image's OpenSSL or libstdc++, and this is the cheapest
# place to find that out. These four are the ones named in SOUL.md as the
# reason the image exists.
log "checking the imports that matter"
python3 - <<'PYCHECK'
import importlib, sys

for module, why in (
    ("googleapiclient", "Gmail, Calendar and Drive"),
    ("google.auth", "the Google OAuth token"),
    ("jwt", "signing the GitHub App JWT"),
    ("cryptography", "the GitHub App private key"),
):
    try:
        importlib.import_module(module)
    except Exception as error:
        sys.exit(f"error: {module} is installed but will not import ({why}): {error}")
print("  imports ok")
PYCHECK

smoke git --version
smoke rg --version
smoke jq --version
