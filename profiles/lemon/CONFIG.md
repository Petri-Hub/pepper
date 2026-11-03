# 🍋 Lemon

> Lemon is a Discord agent being prepared for collaboration on a Roblox game. He speaks plainly with the invited group, can research, plan and remember things with Hermes' general tools, and codes in his own workspace over SSH. DeepSeek powers his replies; the Roblox connections and fuller personality will come later.

## 💬 Platforms

<table>
  <tr>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/discord" width="48" height="48" alt="Discord" /><br>Discord</td>
  </tr>
</table>

## Configuration

### 🧠 Model

DeepSeek Flash gives Lemon an inexpensive starting point for Discord conversation while his development workflow is still being designed. His own API key lives in his profile's `.env`.

```yaml
model:
  provider: deepseek
  default: deepseek-flash
```

### 🤔 Reasoning

Medium effort. DeepSeek Flash thinks at one of four levels, and the middle one is enough to plan a change or read unfamiliar code without making every chat reply slow and expensive.

```yaml
agent:
  reasoning_effort: medium
```

### 🔁 Turn limit

A single message can take Lemon at most 500 steps, like tool calls and searches, before he stops. Hermes has no limit by default, and a cap keeps a task that went wrong from quietly burning through the credits.

```yaml
agent:
  max_turns: 500
```

### 🔒 Conversation search

Hermes' `session_search` can read conversations from another profile, so it is disabled across Lemon's chats and scheduled runs to keep the agents' histories separate. His Discord list already omitted it, but scheduled runs otherwise inherited it from Hermes' defaults.

```yaml
agent:
  disabled_toolsets: [session_search]
```

### 🕒 Timezone

São Paulo time, so anything scheduled for the group fires at the hour Petri means, not in UTC.

```yaml
timezone: America/Sao_Paulo
```

### 💭 Replies

For now his thinking stays on screen, so the group can see how he reads a request; Hermes hides it on Discord by default. Verbose tool progress shows full terminal commands, and Discord's usual 40-character preview would still cut `execute_code` arguments. Removing that preview cap on Discord lets the group see the code he runs; Discord splits messages that exceed its own length limit.

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

Lemon has his own Discord bot. The bot token and the 18 invited users' numeric IDs live in his profile's `.env`, so only those people can talk to him.

He is also allowed to say when the gateway is going offline or is back. A chat where a task is running gets the warning; his home channel is the same Discord channel as Pepper's, which is where a default Discord delivery lands. The switch is Hermes' default, recorded because Mint turns his off.

```yaml
platforms:
  discord:
    enabled: true
    gateway_restart_notification: true
```

### 🧰 Tools

Lemon can research, analyze images, keep task lists, remember, ask for clarification, use Roblox Assets MCP, run commands in his own workspace and read, write, patch and search files directly on Discord. He can also load and manage skills, including his GitHub App workflow, and use `execute_code` to script repeated web, file and terminal calls in his SSH sandbox. That tool does not call Roblox Assets MCP. The list is explicit, so a toolset Hermes adds later does not reach him on its own.

The file tools run as shell commands through the active terminal backend, so they edit the game's files in his SSH sandbox rather than inside Hermes' container.

```yaml
platform_toolsets:
  discord: [web, vision, todo, memory, clarify, roblox-assets, terminal, file, code_execution, skills]
```

### 📚 Skills

Lemon keeps skills for game development, research, creative work, shared media and common documents. His local `github-app-auth` and `code-execution-sandbox` skills stay available. The other installed skills below are disabled across his profile, so they do not appear in his skill index or load when a task only loosely matches them. Disabling a skill does not remove it from disk. New skills are enabled by default unless Lemon disables them later.

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

His commands run in a container of their own in the lab, not in the one Hermes shares with every profile. The lab starts his image as `lemon-sandbox` on the Docker network, publishing no port, and Hermes reaches it over SSH with a key that belongs to him. Commands start in `/home/lemon/workspace`, where the game's repository is checked out; only the `lemon` user can log in, and only with that key.

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

The private key lives in his profile directory, never in this repository, and the public half sits in the lab's `authorized_keys`. The workspace and the container's SSH host key are on the lab's persistent storage, and the lab backs both up every six hours.

The image carries what his day-to-day work needs beyond a shell: `gh`, which spends the installation token described below, `ripgrep` for searching the game's code, and `jq` for API output. The Roblox toolchain is not baked in — each project pins its own versions in `rokit.toml` and `rokit install` fetches them — so replacing the container costs a `rokit install`, not the toolchain's version choice.

The game's regression tests need an Open Cloud key. The lab keeps it in the sandbox's ignored `.env` and passes it to the container as `JEST_ROBLOX_*`, the names the project's Makefile already exports, so no checkout holds a copy of it and nothing is committed by accident.

An SSH session does not inherit the container's environment: sshd builds a fresh one and PAM reads only `/etc/environment`. The entrypoint therefore writes the three variables there before starting sshd, so a login sees the same key a Docker command does.

### 🐙 GitHub App

Lemon works on GitHub as himself, through an App installed on the single repository that matters: the game. His branches, commits and pull requests show up as his bot instead of Petri's account, and the narrow installation means the rest of the account is unreachable with his identity.

There is no personal token and nothing to keep signed in. For each task he mints one token from his own key, lasting about an hour and limited to the permissions that task needs. The key is mounted read-only from the lab's `secrets/` into his profile home, so it never reaches the data volume or the backups, and Hermes carries it into his sandbox where `git push` runs.

```text
App ID         5568797
Installation   177566137
Key            secrets/lemon-github-app.pem → /opt/data/profiles/lemon/github-app.pem (read-only)
```

Those identifiers live in the `github-app-auth` skill in his profile, which is what actually mints a token, not in his `.env` — nothing else reads them. The skill stays on the live agent because it changes with the workflow, not with this repository. It signs its JWT with `openssl`, because his sandbox image has neither PyJWT nor the `cryptography` package.

The repository's default branch is `staging`, and every change he makes is a branch and a pull request against it. Merging stays Petri's call.

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

Lemon uses Hermes' bundled `observability/langfuse` plugin to record turns, model calls and tool calls in the shared Hermes project in Langfuse Cloud's US region. The live Hermes version bundles it; a future update migrates enabled profiles to the official catalog plugin named `langfuse`. Its Python SDK is installed in Hermes' durable package target at version 4.x, and the bundled plugin is enabled only for Lemon with `hermes -p lemon plugins enable observability/langfuse`.

Lemon's own project API key has **Ingestion** permission and lives in `/opt/data/profiles/lemon/.env`; future agents can join the same project with separate keys and per-profile installations. Traces carry profile metadata for filtering. End-user attribution stays off.

The plugin reads capture settings from the shared gateway process, so the [lab Compose service](https://github.com/Petri-Hub/lab/blob/main/services/apps/hermes/compose.yml) sets `HERMES_LANGFUSE_CAPTURE=full`, `HERMES_LANGFUSE_MAX_CHARS=100000` and `HERMES_LANGFUSE_MAX_DEPTH=10`. This exports raw prompts, replies and tool payloads, including any credentials they contain, and applies to any future profile that enables the plugin in this gateway. Long fields can still be truncated, collections stop at 50 items, and `read_file` results keep a head-and-tail preview rather than the entire file.

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

The lab's separate `wakapi-lemon` reporter reads Lemon's Hermes profile and sends activity to his own Wakapi user every five minutes. Its API key and sync state stay in the lab, separate from Pepper's and Mint's.

## 🚧 Not connected yet

Tripwire MCP. Lemon knows this connection is not available yet.

## References

- [Environment variables](.env.example): every variable Lemon needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to him, in the words it was asked for
- [Soul](SOUL.md): who he is, how he talks and the rules he follows
- [Lemon sandbox](https://github.com/Petri-Hub/lab/tree/main/sandboxes/lemon-sandbox): the container his commands run in, in the lab
