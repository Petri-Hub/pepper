# 🍋 Lemon · Changelog

Newest first. Each entry is the ask in plain words, and what it became.

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
