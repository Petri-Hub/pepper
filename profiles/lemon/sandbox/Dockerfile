FROM debian:trixie-slim

# Image metadata — identify Lemon's development sandbox and its source
LABEL org.opencontainers.image.title="lemon-sandbox" \
      org.opencontainers.image.description="Persistent Roblox development workspace for Lemon" \
      org.opencontainers.image.source="https://github.com/Petri-Hub/pepper"

# Pinned releases — verify downloads against their published checksums
ARG ROKIT_VERSION=1.2.0
ARG ROKIT_SHA256=951a7f3ec3d2a5e021fd1867d32f69f010ee4c2927f644b759578afc59c65fc0
ARG CLOUDFLARED_VERSION=2026.10.7
ARG CLOUDFLARED_SHA256=1f99fb518b83dec2ba8d870a7cc991d82a77e6196295a3d2754ba17ab9f91872

# Environment — Lemon's home and Rokit shims for project tools
ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/home/lemon \
    PATH=/home/lemon/.rokit/bin:${PATH}

# System packages — remove generated SSH host keys in the same image layer
RUN apt-get update && apt-get install --no-install-recommends -y \
        blender \
        ca-certificates \
        curl \
        ffmpeg \
        fonts-dejavu-core \
        git \
        jq \
        make \
        openssh-server \
        pre-commit \
        python3-numpy \
        python3-pil \
        python3-venv \
        ripgrep \
        unzip \
    && rm -f /etc/ssh/ssh_host_*

# Package indexes — remove them after installation
RUN rm -rf /var/lib/apt/lists/*

# Roblox Assets MCP — install once in the image, not on each SSH connection
RUN python3 -m venv /opt/roblox-assets-mcp \
    && /opt/roblox-assets-mcp/bin/pip install --no-cache-dir 'roblox-assets-mcp==0.4.0'

# Modal — submit rendering jobs from the SSH workspace
RUN python3 -m venv /opt/modal \
    && /opt/modal/bin/pip install --no-cache-dir 'modal==1.6.3' \
    && ln -s /opt/modal/bin/modal /usr/local/bin/modal

# Base workspace — Lemon user, persistent paths and shell configuration
RUN useradd --create-home --shell /bin/bash lemon \
    && install -d -o lemon -g lemon -m 0755 /home/lemon/workspace \
    && install -d -o lemon -g lemon -m 0700 /home/lemon/.ssh \
    && install -d -m 0700 /var/lib/lemon/ssh

# Rokit — projects pin their own Roblox tool versions
RUN test "$(dpkg --print-architecture)" = amd64 \
    && curl -fsSL -o /tmp/rokit.zip \
        "https://github.com/rojo-rbx/rokit/releases/download/v${ROKIT_VERSION}/rokit-${ROKIT_VERSION}-linux-x86_64.zip" \
    && echo "${ROKIT_SHA256}  /tmp/rokit.zip" | sha256sum -c - \
    && unzip -p /tmp/rokit.zip rokit > /usr/local/bin/rokit \
    && chmod 0755 /usr/local/bin/rokit \
    && rm /tmp/rokit.zip

# Cloudflare Quick Tunnels — cloudflared is used by Rojo Share
RUN test "$(dpkg --print-architecture)" = amd64 \
    && curl -fsSL -o /tmp/cloudflared \
        "https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION}/cloudflared-linux-amd64" \
    && echo "${CLOUDFLARED_SHA256}  /tmp/cloudflared" | sha256sum -c - \
    && install -m 0755 /tmp/cloudflared /usr/local/bin/cloudflared \
    && rm /tmp/cloudflared

# Rokit shims — install them in Lemon's home as his own user
USER lemon
RUN rokit self-install

# SSH — configure the server
USER root
RUN printf '%s\n' \
    'HostKey /var/lib/lemon/ssh/ssh_host_ed25519_key' \
    'PasswordAuthentication no' \
    'KbdInteractiveAuthentication no' \
    'PermitRootLogin no' \
    'PubkeyAuthentication yes' \
    'AllowUsers lemon' \
    'AllowTcpForwarding no' \
    'X11Forwarding no' \
    'SetEnv PATH=/home/lemon/.rokit/bin:/usr/local/bin:/usr/bin:/bin' \
    > /etc/ssh/sshd_config.d/lemon.conf

# Entrypoint — prepare the sandbox when the container starts
COPY --chmod=0755 sandbox/entrypoint.sh /usr/local/bin/lemon-entrypoint

# Asset previews — label thumbnails with their option and name
COPY --chmod=0755 skills/assets-answering/scripts/gallery.py /usr/local/bin/lemon-asset-gallery

# Modal rendering — available to commands in the SSH workspace
COPY skills/rendering-in-modal/scripts/render.py /usr/local/lib/lemon/render.py

# Runtime — start SSH with the persistent workspace as the working directory
WORKDIR /home/lemon/workspace
EXPOSE 22
ENTRYPOINT ["/usr/local/bin/lemon-entrypoint"]
