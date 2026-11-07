FROM python:3.11-slim-bookworm

RUN apt-get update && apt-get install --no-install-recommends -y \
    libgl1 \
    libglib2.0-0 \
    libice6 \
    libopengl0 \
    libsm6 \
    libxkbcommon0 \
    libxrender1 \
    libxi6 \
    libxxf86vm1 \
    libxt6 \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir bpy==4.5.0
