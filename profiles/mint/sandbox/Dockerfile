# Mint's Modal sandbox image. Credentials and skills arrive from his Hermes
# profile at runtime; no account data belongs in this public image.
ARG BASE_IMAGE=nikolaik/python-nodejs:python3.11-nodejs20
FROM ${BASE_IMAGE}

WORKDIR /root
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# Match the pinned dependencies in Hermes' google-workspace setup script.
COPY requirements-google.txt /tmp/requirements-google.txt
RUN python3 -m pip install --no-cache-dir --root-user-action=ignore \
      -r /tmp/requirements-google.txt \
    && python3 -c 'import googleapiclient.discovery, google.auth, google_auth_oauthlib.flow' \
    && rm /tmp/requirements-google.txt

LABEL org.opencontainers.image.title="mint-sandbox" \
      org.opencontainers.image.description="Modal sandbox for Mint's Hermes profile" \
      org.opencontainers.image.source="https://github.com/Petri-Hub/pepper"
