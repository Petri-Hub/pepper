# Pepper's Modal sandbox.
#
# Every terminal command she runs lands in a throwaway Modal sandbox, and until
# now that sandbox was the stock image: no googleapiclient, no jwt, no
# cryptography. Her first Gmail or GitHub call of a session died on
# ModuleNotFoundError, she installed what it asked for and retried, and SOUL.md
# had to spend a paragraph teaching her that this is normal. This image is what
# replaces that paragraph.
#
# Build it with `docker compose build`, which passes every pin from compose.yml.
# A bare docker build works too, but then each version has to be passed by hand:
#   docker build --build-arg OPENCODE_VERSION=… .
#
# Nothing secret belongs in any layer here. Hermes resolves this image with
# modal.Image.from_registry and passes no registry credentials, so the image has
# to be public to be usable at all — every layer is world-readable forever.

# Hermes' own default for terminal.modal_image, so a sandbox built from here
# differs from the stock one only by what the scripts below add. It lives in an
# argument rather than in compose.yml because FROM is resolved before Docker
# can read any file from the build context.
ARG BASE_IMAGE=nikolaik/python-nodejs:python3.11-nodejs20
FROM ${BASE_IMAGE}

# Modal runs her as root in /root, and her Hermes home is /root/.hermes. Nothing
# is written there here: her credentials and her whole skills tree arrive at
# runtime, and /opt/data — the name her container uses for the same home — does
# not exist where her commands run.
WORKDIR /root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    LANG=C.UTF-8

# The helper library every script sources. Copied once, ahead of the scripts, so
# editing a comment in one installer does not invalidate the others.
COPY scripts/lib/common.sh /tmp/build/lib/common.sh

# One layer per upstream, slowest-moving first. Claude Code releases most days
# and is therefore last, after OpenCode's twice a week: bumping it reuses every
# layer above, which is the difference between a CI run that pushes a new tag in
# a minute and one that reinstalls Debian packages to change a single binary.
COPY scripts/install-core.sh requirements-core.txt /tmp/build/
RUN /tmp/build/install-core.sh

ARG WAKATIME_VERSION
COPY scripts/install-wakatime.sh /tmp/build/
RUN /tmp/build/install-wakatime.sh

ARG AI_MEMORY_VERSION
COPY scripts/install-ai-memory.sh /tmp/build/
RUN /tmp/build/install-ai-memory.sh

ARG CODEX_VERSION
COPY scripts/install-codex.sh /tmp/build/
RUN /tmp/build/install-codex.sh

ARG OPENCODE_VERSION
ARG OPENCODE_SHA256
COPY scripts/install-opencode.sh /tmp/build/
RUN /tmp/build/install-opencode.sh

# A sandbox is rebuilt from this image, never updated in place: the pin in
# compose.yml is the version, and a self-update mid-task would make it a lie.
ENV DISABLE_AUTOUPDATER=1
ARG CLAUDE_CODE_VERSION
COPY scripts/install-claude-code.sh /tmp/build/
RUN /tmp/build/install-claude-code.sh

# The WakaTime side of all three agents, which needs no secret. Codex runs its
# hooks with $SHELL -lc, so it is set to the shell the profile script expects.
# IS_SANDBOX lets Claude Code skip its permission prompts as root, which only
# makes sense because this whole machine is a disposable sandbox.
ENV SHELL=/bin/bash \
    IS_SANDBOX=1
ARG WAKATIME_CLAUDE_PLUGIN_VERSION
COPY scripts/configure-agents.sh /tmp/build/
RUN /tmp/build/configure-agents.sh

RUN rm -rf /tmp/build

# The part that needs a secret, done at runtime: a profile script that exports
# the tokens once per session, and the script it calls to write the Wakapi and
# ai-memory config from sandbox/credentials.
COPY --chmod=0644 rootfs/etc/profile.d/pepper-sandbox.sh /etc/profile.d/pepper-sandbox.sh
COPY --chmod=0755 rootfs/usr/local/bin/pepper-sandbox-wire /usr/local/bin/pepper-sandbox-wire

# Recorded so a running sandbox can answer what it is without guessing from a
# binary's --version.
LABEL org.opencontainers.image.title="pepper-sandbox" \
      org.opencontainers.image.description="The Modal sandbox image for the Hermes agents in Petri's lab" \
      org.opencontainers.image.source="https://github.com/Petri-Hub/pepper"
ENV PEPPER_SANDBOX_CLAUDE_CODE=${CLAUDE_CODE_VERSION} \
    PEPPER_SANDBOX_CODEX=${CODEX_VERSION} \
    PEPPER_SANDBOX_OPENCODE=${OPENCODE_VERSION} \
    PEPPER_SANDBOX_AI_MEMORY=${AI_MEMORY_VERSION} \
    PEPPER_SANDBOX_WAKATIME=${WAKATIME_VERSION}

# Modal starts the sandbox itself and runs `sleep infinity` in it, so this is
# only what a person gets when they docker run the image to look around.
CMD ["/bin/bash"]
