# 🍋 Lemon · Changelog

Newest first. Each entry is the ask in plain words, and what it became.

### 2026-11-06 · Draft a planning skill for Lemon

> *"Create a planning skill with a Markdown plan attached in chat and enough technical detail for Lemon to continue after compaction."*

Added a planning skill that keeps a readable group plan and a linked implementation handoff in the thread's scratchpad. The group plan is sent with a Hermes attachment directive; the technical plan records inspected files, decisions and verification. Registered the skill in the profile and sync helper. The draft has not been applied or tested with the live agent, and Markdown attachment delivery from the SSH sandbox remains to be verified.

### 2026-11-06 · Draft Lemon's game design skill

> *"Combine the best parts of those skills so Lemon can think critically about game design and help the group make the game."*

Expanded the design skill with player experience, core loops, game feel, meaningful choices, challenge, accessibility, progression, replayability, retention and playtesting. It guides Lemon to explain tradeoffs and challenge assumptions without taking creative decisions away from the group. The draft has not been applied or tested with the live agent.

### 2026-11-05 · Use a smaller context window

> *"150k max token limit, and ~85% or so it compresses?"*

Set Lemon's working context window to 150,000 tokens and the compression threshold to 85% of the usable input budget. The reply footer now measures usage against that working window.

### 2026-11-05 · Show context usage in replies

> *"Enable it please."*

Enabled the runtime footer with the context-window percentage on final replies, so the group can see how much context Lemon's last model call used.

### 2026-11-04 · Reduce token usage

> *"Threshold, i think you can place 150k, change this in a PR for pepper, commit and push, apply to the live agent and restart (If necessary)."*

Set reasoning effort to low and the context compression trigger to 150,000 tokens to reduce reasoning and repeated context in long conversations.

### 2026-11-04 · Telegram, voice, quieter output, and implement skill

> *"Connect him to Telegram, configure GPT transcribe + voice, remove the verbose output, and update the implement skill."*

Added Telegram as a second platform (`TELEGRAM_BOT_TOKEN`, `TELEGRAM_ALLOWED_USERS`), with reactions enabled so the group gets visual feedback while Lemon works. Added OpenAI Whisper STT fixed to Portuguese and OpenAI TTS, using a separate `VOICE_TOOLS_OPENAI_KEY` credential so the voice key stays decoupled from future model changes. Turned `show_reasoning` and `tool_progress` both off — the group wants clean replies, not traces.

Rewrote the `implement` skill from scratch based on the design brief recorded in `LEMON_IMPLEMENTATION_WORKFLOW.md`: the skill now follows a five-stage loop (intake → look-before-you-build → build → preview-and-iterate → finish), forbids direct delivery to staging, and lists explicit failure modes. The new version was applied to the live agent without a restart; a `/reload-skills` in Lemon's session picks it up.

The other configurations require supplying the Telegram bot token and OpenAI key via 1Password and setting them in the live profile.

### 2026-11-04 · Mark reviewed skills

> *"Mark the assets-search, assets-answering, install, and onboarding skills as confirmed."*

Marked those four skills as confirmed in Lemon's profile so their review status is visible alongside the skill list.

### 2026-11-04 · Keep Lemon's development skills with his profile

> *"I'm thinking of giving the agent skills to Lemon only. Can you bring them here?"*

Moved the seven development skills from roblox-with-swe into Lemon's profile and added them to the skill sync. The setup, preview and test instructions still describe that game. The game repository removes its copies in a separate pull request.

### 2026-11-03 · Remove the separate audio skill

> *"I think we can delete this skill."*

Removed Lemon's Hermes-managed `roblox-audio-assets` skill and its inspection script. The shared asset skills cover searching and presenting audio, with ffprobe available in the sandbox.

### 2026-11-03 · Send audio previews in Discord

> *"He didn't send me the audio in the chat, and I think ffmpeg was missing from his container."*

Added FFmpeg and ffprobe to the sandbox image and installed them in the running sandbox without a restart. The asset presentation skill now explains how to unpack and attach audio, and Lemon's Hermes-managed audio skill no longer forbids attachments. A downloaded Roblox audio file was successfully decoded and inspected in the sandbox; sending attachments in Discord still needs a live test. The image must be rebuilt and deployed to retain FFmpeg after container recreation.

### 2026-11-03 · Make asset options easier to recognize

> *"The users don't care about IDs. Keep the title in bold and the description, and make the preview look like a bookmark with the name and a large letter."*

Asset replies use linked names instead of separate IDs. One gallery helper turns one to eight thumbnails into cards with muted red name headers, large letters, rounded corners and transparent gaps, with long names truncated. It can mark suitable options with a “Favorita do Lemon” badge, show missing previews and display fonts as a vertical list or on dark cards. Audio is presented as playable attachments when available, with duration when known. The skills, SOUL and helper were applied live without restarting; the sandbox rendered a font list and missing preview, while the Discord audio flow still needs testing. The updated sandbox image must be deployed to preserve the helper across recreation.

### 2026-11-03 · Keep shared skills with Lemon's profile

> *"Keep a skills folder at the side of sandbox. These are hard-replaced files."*

Added the shared asset search, asset presentation and onboarding skills to this repository. Applying them replaces the matching live skill directories, including Lemon's edits; other skills stay with Hermes. The sandbox image supplies Pillow and the labeling helper. Project-specific skills live in the game repository. The skills, image and SOUL have not been applied or verified live.

### 2026-11-03 · Give Lemon a foundation for collaboration

> *"Think about his SOUL, what lives there, what lives in project skills, and how to make his environment understandable."*

Rewrote Lemon's SOUL around his Discord collaboration, thread-owned worktrees, previews, coding, assets and project knowledge. Lemon merges his own pull requests after required checks pass, without a code review, and defaults to Brazilian Portuguese when the conversation language is unclear. He uses Git and the workspace layout directly to manage worktrees; a dedicated workspace CLI is deferred. Detailed project procedures belong in the project skills. Skill discovery and the complete workflow still need live verification. The running profile has not been changed.

### 2026-11-03 · Require test settings at sandbox startup

> *"Make it wipe old data, and you can fail if some of those keys are missing."*

The entrypoint replaces `/etc/environment` with the three Open Cloud test settings and stops startup if any are missing or empty. The revised image has not been applied to the live sandbox.

### 2026-11-03 · Install sandbox tools directly

> *"Let's use the direct version without Mise. Can we keep the SSH config inside the Dockerfile?"*

The image installs pinned and checksum-verified releases of Rokit and `cloudflared` directly. Rokit continues to manage each Roblox project's own tools. The Dockerfile also writes the SSH server settings, replacing the separate configuration file. The revised image has not been applied to the live sandbox.

An SSH connection to the local test container showed that direct commands did not inherit the Rokit shims on `PATH`; the SSH configuration now supplies that path to sessions.

### 2026-11-03 · Remove the GitHub CLI

> *"He can't use the GitHub skill, we've tested it in the past. Let's remove GH; this is noise."*

Removed `gh` from the sandbox image. Lemon's GitHub App authentication skill uses its token helper, Git and the GitHub API instead. The updated image has not yet been applied to the live sandbox.

### 2026-11-03 · Remove zrok from the sandbox image

> *"Drop ZROK 100%. We're going to use only Cloudflare Quick Tunnels."*

Removed zrok's binary, version pins and state directory from the image, and removed its setup instructions. Rojo Share uses Cloudflare Quick Tunnels through `cloudflared`. The revised image has not been deployed to the live sandbox.

### 2026-11-03 · Give the workspace a starting layout

> *"The Dockerfile, in its base, should create the tree structure."*

The sandbox entrypoint creates `scratchpad`, `tools`, `projects` and `sessions` inside the persistent workspace as the Lemon user. It runs after the lab's bind mount is in place and leaves existing files and directories alone. Existing checkouts are not moved. The updated image has not yet been applied to the live sandbox.

### 2026-11-03 · Clean up the profile prose and test claim

> *"He can perform automated tests using OCALE. Tripwire is out of scope for now, not planned. Make a general passthrough through the files."*

Shortened `CONFIG.md` to focus on current choices and added Lemon's OCALE test capability to it and `SOUL.md`. Removed Tripwire from the pending list and README references. Configuration values and the live agent were not changed as part of this documentation PR; the proposed soul must be applied and verified before merge.

### 2026-11-02 · Turn off Lemon's built-in memory

> *"Let's deactivate both. We're still setting him up."*

Set `memory.memory_enabled` and `memory.user_profile_enabled` to `false` and removed `memory` from his Discord toolsets. Hermes no longer injects his `MEMORY.md` or `USER.md` into new sessions or offers the built-in memory tool. Their private files were kept so Petri can review them later. This does not change Lemon's skills or skill management.

Applied to the live Lemon profile without restarting the shared gateway. The runtime reported both memory flags off and no Discord memory tool; `skills_list`, `skill_view` and `skill_manage` remained available. Both memory files were still present on disk.

### 2026-11-02 · Curate Lemon's skill index

> *"Keep the creative, research, document and coding skills we selected, including competitor-news-monitor, but remove TDD and the unrelated bundled skills."*

Disabled 31 installed skills across Lemon's profile. His 24 active skills still include the local GitHub App and code execution workflows, plus diagrams, ASCII video, human writing, YouTube content, document formats, maps, code inspection and simplification, debugging, and competitor monitoring. The disabled skills remain installed and can be enabled later. This trims the always-present skill index and avoids loading unrelated procedures for loosely matching requests.

Applied to Lemon's live profile after backing up its configuration, without restarting the shared gateway. `hermes -p lemon skills list --enabled-only` showed exactly 24 skills, and the prompt builder included `competitor-news-monitor` and `code-execution-sandbox` while excluding TDD, Baoyu and the Teams skill. This Hermes version's generic config CLI warns that `skills.disabled` is an unknown key, but its skill resolver and prompt builder honor the value.

### 2026-11-02 · Show full code in Discord progress

> *"Code execution works, but the code shown in Discord still looks cut off."*

`display.tool_progress: verbose` showed full terminal commands, but Discord's default 40-character `tool_preview_length` still shortened `execute_code` arguments. Lemon's Discord display override now sets that length to `0`, leaving the tool call preview uncapped; Discord can split a long progress message at its own message limit. The code execution itself was already running in full.

### 2026-11-02 · Skills and code execution in Discord

> *"Every agent needs skills and skill_manage. Add code_execution for Lemon, and remove session search from all three."*

Lemon's Discord list now includes `skills` and `code_execution`. He can load and manage his own skills and script repeated web, file and terminal calls in his SSH sandbox; `execute_code` does not call Roblox Assets MCP. `agent.disabled_toolsets: [session_search]` also removes conversation search from scheduled runs and CLI sessions, where Hermes' defaults would otherwise provide it.

### 2026-11-02 · Checkpoints out of all three profiles

> *"Remove those checkpoints as they don't make sense."*

The snapshots never ran. Hermes skips them when the file tools work through a container backend, which covers Pepper's and Mint's Modal sandboxes and Lemon's SSH one alike, so there was no restore point to keep. The three sections are gone, `checkpoints.enabled` is unset on the live profiles, and the roadmap no longer lists them.

### 2026-11-02 · The settings Pepper and Mint already had

> *"Lemon needs the configuration the other two already have: medium reasoning, a 500-turn cap, São Paulo time, cron replies without wrappers, checkpoints and gateway shutdown warnings. Oh, and show his thinking for now — and turn on his verbosity so I can see more of the commands he runs in Discord."*

DeepSeek Flash accepts four reasoning levels, and `agent.reasoning_effort: medium` now asks for the middle one instead of Hermes' own default. `agent.max_turns: 500` caps a single message at 500 steps; Hermes runs without a limit otherwise. `timezone: America/Sao_Paulo` puts scheduled work on the group's clock.

`display.show_reasoning: true` keeps his thinking on screen for now; Discord hides it by default. `display.tool_progress: verbose` prints each command in full, in a code block, where Discord's default `all` mode keeps a 40-character one-line preview. `cron.wrap_response: false` delivers a scheduled reply without Hermes' title, job ID, separator and footer.

Gateway restart notices stay enabled, which is Hermes' default and the opposite of Mint's choice. A running task's chat gets the shutdown warning. Lemon's home channel is the same Discord channel as Pepper's, where a default Discord delivery lands; this Hermes version's home-channel broadcast and restart notice read the default profile, so they do not reach his home on their own.

Applied to the live profile with `hermes -p lemon config set`, after a config backup, then the shared gateway was restarted. Six platform connections came back, the values read back from the file, and the display resolver returns `show_reasoning: true` with `tool_progress: verbose` for Discord. No message was sent to Discord just to watch it render.

### 2026-11-02 · zrok out of the pending list

> *"Remove ZROK from the Not connected yet, we will drop from his Dockerfile in a moment."*

Removed zrok from Lemon's pending connections and from the workspace description, and dropped the roadmap item that still planned to evaluate it. His image installs `zrok2` until the separate Dockerfile change removes it.

### 2026-11-02 · Capture full Langfuse context

> *"Listen, we're only using 'metadata'? I need full context."*

The bundled plugin reads capture mode and payload limits from the shared gateway environment, not Lemon's profile `.env`. The earlier profile-only `metadata` setting therefore did not control the running plugin; with no gateway setting, the plugin used its `sanitized` default. Removed that misleading profile variable and set raw `full` capture in the lab's Hermes Compose service, with larger per-field and nesting limits. This sends prompts, replies and tool payloads without secret redaction; the plugin still truncates very long content, limits collections to 50 items and summarizes large file reads. Only Lemon enables the plugin today, but another enabled profile in the same gateway would inherit these capture settings.

After the lab PR merged, Hermes was recreated from the same image with the same data mount. All three profiles came back, the Langfuse SDK remained available and all three lab patches reapplied. A Lemon test turn completed; Petri saw its marker in the Langfuse generation and `capture_mode: full` on the trace.

### 2026-11-02 · Prepare Langfuse tracing

> *"Create the skeleton of things here. I'm going to create the API key on a Hermes project. Consider for now only a PR."*

Added Lemon's Langfuse key names, US Cloud URL and metadata-only capture choice to the public environment example. His profile specifies the bundled `observability/langfuse` plugin used by the live Hermes version, with a Lemon-specific Ingestion key in the shared Hermes project; a future Hermes update migrates it to the official catalog plugin. The Langfuse 4.x SDK is installed in Hermes' durable package target, the credentials are in Lemon's private live profile, and the plugin is enabled there. After Petri confirmed the interruption, the shared gateway restarted, all three profiles came back, and a Lemon test turn produced a trace Petri saw in Langfuse. The key received HTTP 403 when used to read observations, consistent with its ingestion-only scope.

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
