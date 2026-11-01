# Lemon's development image

This image gives Lemon a persistent Linux workspace with SSH access. It includes Git, Make, pre-commit and Rokit. For a project with a `rokit.toml`, run `rokit install` in its checkout to install its pinned tools. The image has no game-specific tool versions or source files; projects can add other tools as needed.

The image currently targets Linux x86-64, matching the lab host and GitHub Actions runner.

## Check the toolchain locally

```bash
docker build -t lemon-sandbox:dev profiles/lemon/sandbox
docker run --rm --user lemon --entrypoint /bin/bash \
  --mount "type=bind,src=$(realpath ../roblox-with-swe),dst=/home/lemon/workspace/roblox-with-swe" \
  lemon-sandbox:dev -lc 'cd roblox-with-swe && rokit install --no-trust-check && wally install && make format-check && make lint && make build'
```

For this test game, `make test-on-ocale` also needs its `JEST_ROBLOX_OPEN_CLOUD_API_KEY`, `JEST_ROBLOX_UNIVERSE_ID` and `JEST_ROBLOX_PLACE_ID` at runtime. None are built into this image. `make test-on-system` needs Roblox Studio and is for a tester's machine.

## Run the SSH workspace

The lab will run this image on its Docker network, mount a persistent volume at `/home/lemon/workspace` for multiple repository directories, and mount a public `authorized_keys` file at `/home/lemon/.ssh/authorized_keys`. Mount a separate persistent volume at `/var/lib/lemon/ssh` so SSH keeps the same host identity across container replacements. The container listens on port 22; it does not need a host port published when Hermes reaches it on the lab network.

Only the `lemon` user can log in, with a public key. The image contains no checkout, SSH client private key, Roblox credential, GitHub App credential or zrok configuration. Those belong to the running service and workspaces. Rojo can serve from a project's checkout; exposing it through zrok remains a separate step.
