# 🍋 Lemon

> Lemon helps a Discord group build a Roblox game. He speaks plainly with coders and non-coders, researches ideas and assets, and works on the game's code in his own SSH workspace. DeepSeek powers his replies; he merges his changes after the required checks pass.

## 💬 Platforms

<table>
  <tr>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/discord" width="48" height="48" alt="Discord" /><br>Discord</td>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/telegram" width="48" height="48" alt="Telegram" /><br>Telegram</td>
  </tr>
</table>

## Configuration

### 🧠 Model

DeepSeek Flash keeps Lemon's Discord conversations and coding help inexpensive. His API key stays in his private profile.

```yaml
model:
  provider: deepseek
  default: deepseek-flash
  context_length: 150000
```

### 🤔 Reasoning

Low effort reduces reasoning tokens across Lemon's Discord conversations and development work.

```yaml
agent:
  reasoning_effort: low
```

### 🗜️ Context compression

Lemon uses a 150,000-token working context window and starts compressing near 85% of its usable input budget. This leaves room for new messages and reduces the old context sent on later calls; output-token reservation can make the trigger lower than 127,500 tokens.

```yaml
compression:
  threshold: 0.85
```

### 🔁 Turn limit

The 500-step cap stops a runaway task from consuming credits indefinitely.

```yaml
agent:
  max_turns: 500
```

### 🔒 Conversation search

Hermes' `session_search` can read another profile's conversations, so Lemon disables it across chats and scheduled runs.

```yaml
agent:
  disabled_toolsets: [session_search]
```

### 🧠 Built-in memory

Lemon's built-in agent notes and user profile are off while his role takes shape. New sessions omit both memory blocks and the built-in memory tool; the private files remain available for later review. His skills remain enabled.

```yaml
memory:
  memory_enabled: false
  user_profile_enabled: false
```

### 🕒 Timezone

São Paulo time, so anything scheduled for the group fires at the hour Petri means, not in UTC.

```yaml
timezone: America/Sao_Paulo
```

### 💭 Replies

Lemon hides reasoning but keeps tool progress on so the group can follow what he is doing. A footer on final replies shows the last model call's context-window percentage. The custom preview length cap is removed, leaving Hermes' default.

```yaml
display:
  show_reasoning: false
  tool_progress: verbose
  runtime_footer:
    enabled: true
    fields: [context_pct]
```

### 🎙️ Voice

Lemon transcribes Telegram voice messages with OpenAI Whisper and replies in audio when asked, using OpenAI TTS. The language is fixed to Portuguese so Whisper does not misidentify short clips.

```yaml
stt:
  provider: openai
  language: pt

tts:
  provider: openai
  openai:
    voice: ballad
```

```bash
VOICE_TOOLS_OPENAI_KEY=…
```

### ⏰ Scheduled replies

His scheduled replies arrive as he wrote them, without Hermes adding a cron title, job ID, separator or footer on any platform.

```yaml
cron:
  wrap_response: false
```

### 📡 Messaging

Lemon's Discord bot accepts messages from an 18-person allowlist, with IDs and token in his private `.env`. Gateway restart notices remain on; his home channel is Pepper's Discord channel, though this Hermes version sends home-channel notices only for the default profile.

His Telegram bot uses the same allowlist principle. Users who may contact him by DM are listed in `TELEGRAM_ALLOWED_USERS`; group-only access is set separately. Reactions give visual feedback while he works.

```yaml
platforms:
  discord:
    enabled: true
    gateway_restart_notification: true
  telegram:
    enabled: true
    reactions: true
```

### 🧰 Tools

Lemon's Discord and Telegram tools cover research, image analysis, tasks, Roblox assets, terminal and file access, code execution, skill management and text-to-speech replies. Terminal and file tools work in his SSH sandbox. `execute_code` can script repeated web, file and terminal calls, but cannot call Roblox Assets MCP. The `tts` toolset supplies `text_to_speech`, so the voice configured above is a tool he can actually call.

```yaml
platform_toolsets:
  discord: [web, vision, todo, clarify, roblox-assets, terminal, file, code_execution, skills, tts]
  telegram: [web, vision, todo, clarify, roblox-assets, terminal, file, code_execution, skills, tts]
```

### 📚 Skills

Lemon keeps skills for game development, research, creative work, media and documents, including his local GitHub App and code execution workflows. The shared skills below live in this repository and apply across projects.

| Skill | Purpose | Status |
|---|---|---|
| [`assets-search`](skills/assets-search/SKILL.md) | Find and evaluate Roblox Creator Store assets. | Confirmed |
| [`assets-answering`](skills/assets-answering/SKILL.md) | Present labeled asset previews in Discord. | Confirmed |
| [`onboarding`](skills/onboarding/SKILL.md) | Introduce Lemon and help collaborators connect Studio. | Confirmed |
| [`controls`](skills/controls/SKILL.md) | Explain skill shortcuts and session commands. | — |
| [`design`](skills/design/SKILL.md) | Explore gameplay and creative decisions with the group. | — |
| [`plan`](skills/plan/SKILL.md) | Prepare a group plan and a technical handoff. | — |
| [`implement`](skills/implement/SKILL.md) | Implement an agreed feature or fix. | — |
| [`install`](skills/install/SKILL.md) | Set up the roblox-with-swe toolchain in a worktree. | Confirmed |
| [`model`](skills/model/SKILL.md) | Create and integrate custom Blender assets for Roblox. | — |
| [`rendering`](skills/rendering/SKILL.md) | Render Blender previews on a short-lived Modal GPU. | — |
| [`texture`](skills/texture/SKILL.md) | Find and choose textures and materials. | — |
| [`texture-answering`](skills/texture-answering/SKILL.md) | Present texture previews and material choices. | — |
| [`texture-search-in-ambientcg`](skills/texture-search-in-ambientcg/SKILL.md) | Find ambientCG texture maps. | — |
| [`texture-search-in-polyhaven`](skills/texture-search-in-polyhaven/SKILL.md) | Find Poly Haven texture maps. | — |
| [`serve`](skills/serve/SKILL.md) | Manage a roblox-with-swe Studio preview. | — |
| [`test`](skills/test/SKILL.md) | Check changes and coordinate Studio playtesting. | — |
| [`document`](skills/document/SKILL.md) | Record game decisions and contributor guidance. | — |
| [`deliver`](skills/deliver/SKILL.md) | Deliver a change through checks and merge. | — |

Run [`sync-skills.sh`](sync-skills.sh) with Lemon's existing profile skills directory as its argument when applying this configuration; it requires `rsync` and write access to that directory. It replaces the listed skill directories in full, including files Lemon changed or added inside them. His other skills remain managed by Hermes. The sandbox image supplies the asset-labeling helper used by `assets-answering`.

Hermes reserves `/model` for its built-in model selection command. Invoke the modelling skill explicitly with `/skill model`, or ask Lemon to use it in conversation.

The listed disabled skills are hidden from his prompt but remain installed; new skills are enabled unless explicitly disabled. The setup, preview and test skills currently describe roblox-with-swe's toolchain; project documentation remains in the game repository.

```yaml
skills:
  disabled:
    - airtable
    - arxiv
    - baoyu-infographic
    - box
    - claude-code
    - claude-design
    - codex
    - computer-use
    - design-md
    - document-to-action-items
    - dogfood
    - email-inbox-triage
    - google-workspace
    - himalaya
    - inspecting-hermes-desktop-dom
    - llm-wiki
    - manim-video
    - meeting-action-items
    - node-inspect-debugger
    - notion
    - obsidian
    - opencode
    - popular-web-designs
    - product-price-monitor
    - python-debugpy
    - requesting-code-review
    - songsee
    - teams-meeting-pipeline
    - test-driven-development
    - weekly-review-planning
    - xurl
```

### 🖥️ Workspace

Lemon's terminal and file tools use a persistent lab container over SSH, isolated from the shared Hermes container. The game's repository is checked out in `/home/lemon/workspace`, and only his SSH key grants access. The image carries Blender, `ripgrep`, `jq`, Rokit and `cloudflared`; the project pins its Roblox tools separately. Blender scripts can use `bpy` through Blender's bundled Python in background mode. Debian's Blender build lacks OpenImageDenoise support, so disable Cycles denoising for headless renders.

The workspace can run the game's automated tests through OCALE, alongside formatting, linting and build checks. FFmpeg and ffprobe inspect and convert media for audio previews.

The sandbox includes the Modal client. The lab supplies `MODAL_TOKEN_ID` and `MODAL_TOKEN_SECRET` to its entrypoint, which requires both and makes them available to SSH sessions. The `rendering` skill sends packed Blender scenes to a separate `lemon-render` image on Modal; the image runs a single-use T4 function with no warm pool. FBX export remains local.

```yaml
terminal:
  backend: ssh
  ssh_host: lemon-sandbox
  ssh_user: lemon
  ssh_key: /opt/data/profiles/lemon/ssh/lemon_sandbox_ed25519
  cwd: /home/lemon/workspace
  credential_files:
    - github-app.pem
```

### 🐙 GitHub App

Lemon uses a GitHub App installed only on the game repository. Its short-lived tokens let him create branches and pull requests under his bot identity. The private key is mounted read-only from the lab and copied into his sandbox for Git operations. He opens pull requests against `staging` and merges them after the required checks pass.

```text
App ID         5568797
Installation   177566137
Key            secrets/lemon-github-app.pem → /opt/data/profiles/lemon/github-app.pem (read-only)
```

The `github-app-auth` skill holds these identifiers and mints the tokens. Hermes manages the skill outside this repository.

### 🔌 MCP servers

Roblox Assets MCP lets Lemon search Creator Store listings, inspect asset metadata, request temporary download links, and upload and manage owned assets. Hermes starts the server over SSH in Lemon's sandbox, so it can read files from his workspace. Its Open Cloud key and configured upload owner are supplied to the sandbox by the lab, not by Hermes. Uploading an asset does not create a public Creator Store listing.

| Server | What it gives the agent | Link |
|---|---|---|
| `roblox-assets` | Creator Store search, delivery and owned asset lifecycle management | [Roblox Assets MCP](https://github.com/Petri-Hub/roblox-assets-mcp) |

```yaml
mcp_servers:
  roblox-assets:
    command: ssh
    args:
      - -T
      - -o
      - BatchMode=yes
      - -o
      - StrictHostKeyChecking=yes
      - -o
      - UserKnownHostsFile=/opt/data/profiles/lemon/ssh/known_hosts
      - -i
      - /opt/data/profiles/lemon/ssh/lemon_sandbox_ed25519
      - lemon@lemon-sandbox
      - /opt/roblox-assets-mcp/bin/roblox-assets-mcp
```

Use the actual private-key path configured for Lemon's terminal if it differs. Before enabling this configuration, add the sandbox's verified persistent SSH host public key to the specified `known_hosts` file under the hostname `lemon-sandbox`; the lab's sandbox README describes the key's location. Keep any existing entries. SSH must be able to authenticate non-interactively, and the host key must match after container replacement. SSH carries MCP protocol messages over standard input and output; do not add a terminal (`-T`) or commands that print banners to standard output.

### 🧱 Plugins

Hermes' `observability/langfuse` plugin records Lemon's turns, model calls and tools in a shared Langfuse project. His own Ingestion key stays in his private profile, traces carry profile metadata, and end-user attribution is off. The lab configures full capture for the gateway, including raw prompts, replies and tool payloads; any profile enabling the plugin shares that capture setting.

| Plugin | What it gives the agent | Link |
|---|---|---|
| `observability/langfuse` | Profile-scoped traces of turns, model calls, tools, usage and cost | [Hermes Langfuse plugin](https://hermes-agent.nousresearch.com/docs/plugins/langfuse) |

```yaml
plugins:
  enabled:
    - observability/langfuse
```

```bash
HERMES_LANGFUSE_PUBLIC_KEY=…
HERMES_LANGFUSE_SECRET_KEY=…
HERMES_LANGFUSE_BASE_URL=https://us.cloud.langfuse.com
```

### ⏱️ Wakapi

The lab's `wakapi-lemon` reporter sends Lemon's activity to his own Wakapi user every five minutes, separate from Pepper's and Mint's stats.

## References

- [Environment variables](.env.example): every variable Lemon needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to him, in the words it was asked for
- [Soul](SOUL.md): who he is, how he talks and the rules he follows
- [Lemon sandbox](https://github.com/Petri-Hub/lab/tree/main/sandboxes/lemon-sandbox): the container his commands run in, in the lab
