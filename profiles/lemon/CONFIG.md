# 🍋 Lemon

> Lemon helps a Discord group build a Roblox game. He speaks plainly with coders and non-coders, researches ideas and assets, and works on the game's code in his own SSH workspace. DeepSeek powers his replies; he merges his changes after the required checks pass.

## 💬 Platforms

<table>
  <tr>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/discord" width="48" height="48" alt="Discord" /><br>Discord</td>
  </tr>
</table>

## Configuration

### 🧠 Model

DeepSeek Flash keeps Lemon's Discord conversations and coding help inexpensive. His API key stays in his private profile.

```yaml
model:
  provider: deepseek
  default: deepseek-flash
```

### 🤔 Reasoning

Medium effort helps Lemon plan changes and read unfamiliar code without slowing every reply.

```yaml
agent:
  reasoning_effort: medium
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

Lemon shows reasoning and verbose tool progress in Discord so the group can see how he approaches a request. The preview cap is removed to show full `execute_code` arguments, subject to Discord's message limit.

```yaml
display:
  show_reasoning: true
  tool_progress: verbose
  platforms:
    discord:
      tool_preview_length: 0
```

### ⏰ Scheduled replies

His scheduled replies arrive as he wrote them, without Hermes adding a cron title, job ID, separator or footer on any platform.

```yaml
cron:
  wrap_response: false
```

### 📡 Messaging

Lemon's Discord bot accepts messages from an 18-person allowlist, with IDs and token in his private `.env`. Gateway restart notices remain on; his home channel is Pepper's Discord channel, though this Hermes version sends home-channel notices only for the default profile.

```yaml
platforms:
  discord:
    enabled: true
    gateway_restart_notification: true
```

### 🧰 Tools

Lemon's Discord tools cover research, image analysis, tasks, Roblox assets, terminal and file access, code execution, and skill management. Terminal and file tools work in his SSH sandbox. `execute_code` can script repeated web, file and terminal calls, but cannot call Roblox Assets MCP.

```yaml
platform_toolsets:
  discord: [web, vision, todo, clarify, roblox-assets, terminal, file, code_execution, skills]
```

### 📚 Skills

Lemon keeps skills for game development, research, creative work, media and documents, including his local GitHub App and code execution workflows. The shared skills below live in this repository and apply across projects.

| Skill | Purpose |
|---|---|
| [`assets-search`](skills/assets-search/SKILL.md) | Find and evaluate Roblox Creator Store assets. |
| [`assets-answering`](skills/assets-answering/SKILL.md) | Present labeled asset previews in Discord. |
| [`onboarding`](skills/onboarding/SKILL.md) | Introduce Lemon and help collaborators connect Studio. |

Run [`sync-skills.sh`](sync-skills.sh) with Lemon's existing profile skills directory as its argument when applying this configuration; it requires `rsync` and write access to that directory. It replaces those three skill directories in full, including files Lemon changed or added inside them. His other skills remain managed by Hermes. The sandbox image supplies the asset-labeling helper used by `assets-answering`.

The listed disabled skills are hidden from his prompt but remain installed; new skills are enabled unless explicitly disabled. Project-specific skills belong to each project; their discovery from Lemon's SSH workspace still needs verification.

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

Lemon's terminal and file tools use a persistent lab container over SSH, isolated from the shared Hermes container. The game's repository is checked out in `/home/lemon/workspace`, and only his SSH key grants access. The image carries `ripgrep`, `jq`, Rokit and `cloudflared`; the project pins its Roblox tools separately.

The workspace can run the game's automated tests through OCALE, alongside formatting, linting and build checks. FFmpeg and ffprobe inspect and convert media for audio previews.

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

Roblox Assets MCP lets Lemon search Creator Store listings, inspect asset metadata and request temporary download links. The server runs in his Hermes profile with its own Roblox Open Cloud key. Assets can be fetched into his workspace; getting them into the game still needs a Studio session or an Open Cloud path he does not have yet.

| Server | What it gives the agent | Link |
|---|---|---|
| `roblox-assets` | Creator Store search, details and temporary asset URLs | [Roblox Assets MCP](https://github.com/Petri-Hub/roblox-assets-mcp) |

```yaml
mcp_servers:
  roblox-assets:
    command: uvx
    args: [roblox-assets-mcp]
    env:
      ROBLOX_API_KEY: "${ROBLOX_API_KEY}"
```

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
