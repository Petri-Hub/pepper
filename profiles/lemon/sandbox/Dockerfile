FROM debian:bookworm-slim

ARG ROKIT_VERSION=1.2.0
ARG ROKIT_SHA256=951a7f3ec3d2a5e021fd1867d32f69f010ee4c2927f644b759578afc59c65fc0
ARG GH_VERSION=2.103.3
ARG GH_SHA256=4c806978ffce1cec70853302a56d70ac6da4f19bae7adca4e1a8ab00633dd91d

ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/home/lemon \
    PATH=/home/lemon/.rokit/bin:${PATH}

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        ca-certificates curl git jq make openssh-server pre-commit ripgrep unzip \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash lemon \
    && install -d -o lemon -g lemon -m 0755 /home/lemon/workspace \
    && install -d -o lemon -g lemon -m 0700 /home/lemon/.ssh \
    && install -d -m 0700 /var/lib/lemon/ssh \
    && printf '%s\n' 'export PATH="$HOME/.rokit/bin:$PATH"' > /etc/profile.d/lemon-rokit.sh \
    && rm -f /etc/ssh/ssh_host_*

# Each project selects its own tool versions in its rokit.toml.
RUN test "$(dpkg --print-architecture)" = amd64 \
    && curl -fsSL -o /tmp/rokit.zip \
        "https://github.com/rojo-rbx/rokit/releases/download/v${ROKIT_VERSION}/rokit-${ROKIT_VERSION}-linux-x86_64.zip" \
    && echo "${ROKIT_SHA256}  /tmp/rokit.zip" | sha256sum -c - \
    && unzip -p /tmp/rokit.zip rokit > /usr/local/bin/rokit \
    && chmod 0755 /usr/local/bin/rokit \
    && rm /tmp/rokit.zip

# gh is not in Debian's repositories, so its release tarball is pinned the same
# way rokit's is. It never logs in on its own: it spends the installation token
# the GitHub App skill mints.
RUN test "$(dpkg --print-architecture)" = amd64 \
    && curl -fsSL -o /tmp/gh.tar.gz \
        "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz" \
    && echo "${GH_SHA256}  /tmp/gh.tar.gz" | sha256sum -c - \
    && tar -xzOf /tmp/gh.tar.gz "gh_${GH_VERSION}_linux_amd64/bin/gh" > /usr/local/bin/gh \
    && chmod 0755 /usr/local/bin/gh \
    && rm /tmp/gh.tar.gz

USER lemon
RUN rokit self-install

USER root
COPY sshd.conf /etc/ssh/sshd_config.d/lemon.conf
COPY --chmod=0755 entrypoint.sh /usr/local/bin/lemon-entrypoint

WORKDIR /home/lemon/workspace
EXPOSE 22
LABEL org.opencontainers.image.title="lemon-sandbox" \
      org.opencontainers.image.description="Persistent Roblox development workspace for Lemon" \
      org.opencontainers.image.source="https://github.com/Petri-Hub/pepper"
ENTRYPOINT ["/usr/local/bin/lemon-entrypoint"]
