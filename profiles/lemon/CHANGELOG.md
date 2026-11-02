# 🍋 Lemon · Changelog

Newest first. Each entry is the ask in plain words, and what it became.

### 2026-11-02 · Prepare Langfuse tracing

> *"Create the skeleton of things here. I'm going to create the API key on a Hermes project. Consider for now only a PR."*

Added Lemon's Langfuse key names, US Cloud URL and metadata-only capture choice to the public environment example. The profile documents the official per-profile plugin, the Ingestion key permission, and the shared Hermes project plan; the roadmap keeps the connection open. No key, plugin, live profile or gateway was changed. After the key is stored in 1Password, the live profile still needs its values, a plugin install, a confirmed shared-gateway restart and a test trace.

### 2026-11-01 · Prepare zrok in Lemon's image

> *"Create an image with ZROK2 installed, start the container, run some commands there and enable it."*

Added a pinned zrok2 binary to Lemon's image. The lab still needs a persistent mount for his zrok environment before the updated container can be enabled with the account token from 1Password; no token or enabled state is in the image. Starting a Rojo share from a Discord thread is still separate work.

### 2026-11-01 · A key the tests can reach

> *"I think we shouldn't base ourselves on .env, should us? Shouldn't we bind this API key in the environment or something?"*

Right, and it is bound in the environment instead. A `.env` inside the checkout would have put a copy of the key in the repository, in the snapshot and one `git add -A` away from a commit. The lab sets it once in the sandbox's ignored `.env`, and compose passes it to the container as `JEST_ROBLOX_*`, which the game's Makefile already exports — so the checkout needs nothing.

It reached nothing at first. An SSH session does not inherit the container's environment, and Lemon searched everywhere for a key that was never in his shell; the tests had only ever run through `docker exec`. The entrypoint now writes the three variables into `/etc/environment`, which `pam_env` reads, so his own commands see them too.

### 2026-11-01 · Tools for the work, not just a shell

> *"I've noticed he ran loads of shell commands, I think it was creating friction for him."*

His first real session was nineteen shell calls. Six were only looking around, `cat` read the files and heredocs wrote them, and `curl` piped through `python3` opened the pull request.

He now has Hermes' file tools on Discord. They run as shell commands through his SSH backend, so they edit the game's files inside his sandbox rather than the container Hermes runs in. His image gained `gh`, `ripgrep` and `jq`; `gh` still has no App authentication of its own, so the minting skill stays, but a pull request is one command instead of a hand-built JSON body.

### 2026-11-01 · His own GitHub identity

> *App ID: 5568797 / Key is at Downloads. / Installation ID: 177566137.*

Lemon now works on GitHub as `lemon-podcast-3-0-s-bot[bot]`, installed on `Petri-Hub/roblox-with-swe` alone, with write on contents, pull requests, issues, actions and workflows. The key lives in the lab's `secrets/` and reaches his profile home, from where Hermes carries it into his sandbox; the mount was the only reason the container needed recreating.

His `github-app-auth` skill is his own copy rather than Pepper's: his App and installation IDs, his bot name and noreply address, and the rules that fit one repository — branch from `staging`, which is the default branch, and leave merging to Petri. Its minting script was rewritten to sign with `openssl`, because his sandbox has neither PyJWT nor `cryptography`; a bare `python3` runs it now. His `SOUL.md` says he can branch, commit and open pull requests, and cannot run the game's automated tests or publish.

Also: his avatar was 2.7 MB at 2048×2048, over Discord's image limit, and is now 399 KB at 1024×1024.

### 2026-11-01 · Workspace and terminal live

> *I've merged the 'lab' PR, and the Restic password is in my clipboard. SSH keys were generated at ~/.ssh/personal. I think you can start leveraging things.*

Lemon's container now runs in the lab and his terminal reaches it. The image published earlier is pulled as `lemon-sandbox` on the lab network with no host port; his workspace and the container's SSH host key persist, and the new `restic-lemon-sandbox` job initialized its repository and took a first snapshot with the password from the clipboard. Only the toolchain output each project regenerates is left out of the snapshot.

His terminal uses Hermes' SSH backend, configured in `config.yaml` rather than `.env` because that file is for credentials: `lemon-sandbox`, user `lemon`, key in his profile directory, starting in `/home/lemon/workspace`. The `terminal` toolset is now enabled on Discord, and his `SOUL.md` says what he can and cannot do with it. The game's repository is checked out in the workspace, where `rokit install`, `wally install`, `make format-check`, `make lint` and `make build` all passed. Pull requests, automated game tests and publishing still need the GitHub App and Roblox credentials.

### 2026-11-01 · Persistent Roblox development image prepared

> *Create a reusable image for Lemon's Roblox projects, using roblox-with-swe to check its toolchain, and leave GitHub integration for later.*

Added an SSH-ready Docker image and a publishing workflow. The image contains Git, Make, pre-commit and Rokit; projects with Rokit manifests install their own pinned tools. SSH host keys stay outside the image for a persistent lab container. Format, lint and build checks were verified with roblox-with-swe. Open Cloud tests still need runtime credentials; Studio tests remain on a tester's machine. The image is not yet connected to Lemon's live Hermes profile.

### 2026-11-01 · Roblox Assets MCP connected

> *The Discord is working, reply is OK. Tracking is done. Can you wire my Roblox Assets MCP?*

Added the Roblox Open Cloud key to Lemon's ignored local and live profile environments, connected `roblox-assets-mcp` through `uvx`, and enabled its three tools on Discord. The server started and discovered all three tools. Lemon can find and inspect assets; importing them into the game still needs his isolated workspace. The roadmap now records Discord replies and Wakapi tracking as done.

### 2026-11-01 · Lemon's Wakapi card

> *Add the Wakapi tracking of Lemon in the README.md, exactly like the ones from the other agents.*

Added a Lemon card beside Pepper and Mint, and extended the nightly GitHub Actions workflow to refresh it from his own Wakapi account.

### 2026-11-01 · Lemon connected to DeepSeek and Discord

> *The API key for DeepSeek is at my clipboard.*

Created Lemon's live Hermes profile with DeepSeek Flash, his minimal SOUL and his own Discord bot credentials. Hermes connected the Discord adapter without restarting Pepper or Mint, and a one-shot model reply succeeded. Lemon has general research, planning and memory tools; local terminal and file access are held until he has an isolated workspace. The lab's `wakapi-lemon` reporter is also running with his own Wakapi user. A human reply in the Discord server remains to be checked.

### 2026-11-01 · First chat profile

> *The API key for DeepSeek is at my clipboard.*

Selected DeepSeek Flash for Lemon's initial Discord conversations and saved the key in his gitignored local `.env`. Added a minimal SOUL and profile configuration. Hermes' general tools remain available; Roblox-specific MCP servers and engineering setup remain on the roadmap.

### 2026-11-01 · Discord bot credentials prepared locally

> *These are the allowed users for the bot. The bot token is on my clipboard.*

Saved the 18 allowed user IDs and the supplied bot token in Lemon's gitignored local `.env`. The token was accepted by Discord for the Lemon bot. His live Hermes profile has not been created yet.

### 2026-11-01 · Lemon V1 avatar

> *The Lemon V1 avatar is in my Downloads folder; pick it.*

Added the supplied image as `avatar.png` for Lemon's profile, preserving its square composition. His Discord bot still needs the same image uploaded in the Developer Portal.

### 2026-11-01 · Prepare Lemon's first conversation

> *This agent will be called Lemon. Configure him so we can at least talk to him in Discord, with DeepSeek, before the Roblox tools and specialized prompt.*

Prepared placeholders for Lemon's own DeepSeek API key, Discord bot token and initial user allowlist. The repository roadmap now separates his first conversation from the later Roblox engineering connections. No live Hermes profile or Discord bot has been configured yet.
