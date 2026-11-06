# Lemon's development image

This Debian Trixie image gives Lemon a persistent Linux workspace with SSH access. It includes Blender, Git, Make, pre-commit, Rokit and `cloudflared`, an asset-preview labeling helper with Pillow, and Roblox Assets MCP 0.3.0 in `/opt/roblox-assets-mcp`. Debian supplies Blender and Python; Blender's own Python includes `bpy` for scripts run with `blender --background --python script.py`. The MCP package is installed separately in a virtual environment. For a project with a `rokit.toml`, run `rokit install` in its checkout to install its pinned tools. The image has no game-specific tool versions or source files; projects can add other tools as needed.

The image currently targets Linux x86-64, matching the lab host and GitHub Actions runner.

## Check the toolchain locally

```bash
docker build -f profiles/lemon/sandbox/Dockerfile -t lemon-sandbox:dev profiles/lemon
docker run --rm --user lemon --entrypoint /bin/bash \
  --mount "type=bind,src=$(realpath ../roblox-with-swe),dst=/home/lemon/workspace/roblox-with-swe" \
  lemon-sandbox:dev -lc 'cd roblox-with-swe && rokit install --no-trust-check && wally install && make format-check && make lint && make build'
```

The sandbox requires `JEST_ROBLOX_OPEN_CLOUD_API_KEY`, `JEST_ROBLOX_UNIVERSE_ID` and `JEST_ROBLOX_PLACE_ID` at startup so SSH sessions can run `make test-on-ocale`. None are built into the image. `make test-on-system` needs Roblox Studio and is for a tester's machine.

`ROBLOX_API_KEY` is required at sandbox startup and is passed to SSH sessions through PAM. Configure it in the lab service, not in the image or Hermes profile. The installed release supports search, delivery and asset lifecycle management, including uploads; it does not publish Creator Store listings.

## Run the SSH workspace

The lab will run this image on its Docker network, mount a persistent volume at `/home/lemon/workspace` for multiple repository directories, and mount a public `authorized_keys` file at `/home/lemon/.ssh/authorized_keys`. Mount a separate persistent volume at `/var/lib/lemon/ssh` so SSH keeps the same host identity across container replacements. The container listens on port 22; it does not need a host port published when Hermes reaches it on the lab network.

Only the `lemon` user can log in, with a public key. The image contains no checkout, SSH client private key, Roblox credential or GitHub App credential. Those belong to the running service and workspaces.

For remote Studio previews, Rojo Share uses Cloudflare Quick Tunnels through `cloudflared`, alongside the project-pinned Rojo and Rojo Share tools.
