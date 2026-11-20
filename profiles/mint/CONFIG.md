# 🌿 Mint

> Mint is Bárbara's concise, polished personal assistant, with the manner of an old family butler from the films, paternal, dryly ironic and unflappable, and a little chocolate-mint wit. He helps with everyday questions, design discussions and reminders on Telegram, Discord and voice, thinks with OpenAI, and runs commands in his own Modal sandbox. Google Workspace, Notion, Vercel and Home Assistant are connected to his profile, and a Home Assistant voice satellite lets her talk to him out loud at home.

## 💬 Platforms

<table>
  <tr>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/telegram" width="48" height="48" alt="Telegram" /><br>Telegram</td>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/discord" width="48" height="48" alt="Discord" /><br>Discord</td>
  </tr>
</table>

## Configuration

### 🧠 Model

GPT-6 Luna handles Mint's everyday questions and tasks, with GPT-5.6 Luna as a fallback. Both use his own OpenAI key.

```yaml
model:
  provider: openai-api
  default: gpt-6-luna
  context_length: 150000
```

```yaml
fallback_model:
  - provider: openai-api
    model: gpt-5.6-luna
```

### 🤔 Reasoning

Medium effort gives Mint room to reason through a task without slowing simple replies too much.

```yaml
agent:
  reasoning_effort: medium
```

### 🗜️ Context compression

Mint uses a 150,000-token working context window and starts compressing near 85% of its usable input budget, matching Lemon. Output-token reservation can make the trigger lower than 127,500 tokens.

```yaml
compression:
  threshold: 0.85
```

### 🔁 Turn limit

At most 500 steps per message, so a task that goes wrong cannot keep running indefinitely.

```yaml
agent:
  max_turns: 500
```

### 🔒 Conversation search

Hermes' `session_search` can read another profile's conversations, so Mint disables it across chats and scheduled runs. Skills and skill management remain available.

```yaml
agent:
  disabled_toolsets: [session_search]
```

### 🕒 Timezone

Americana follows São Paulo time, so reminders and other scheduled work use the local hour.

```yaml
timezone: America/Sao_Paulo
```

### 💭 Replies

Mint streams replies and can react without sending a full message. He hides reasoning, tool progress and long-running status updates, and sends no acknowledgment when busy. A lab patch makes the busy setting profile-specific in this Hermes version.

```yaml
display:
  show_reasoning: false
  streaming: true
  message_reactions: true
  busy_ack_enabled: false
  busy_steer_ack_enabled: false
  long_running_notifications: false
  tool_progress: false
```

### ⏰ Scheduled replies

His scheduled replies arrive without Hermes adding a cron title, job ID, separator or footer on any platform.

```yaml
cron:
  wrap_response: false
```

### 🎙️ Voice

OpenAI transcribes Mint's voice notes and speaks his replies in Onyx, with a sincere, reassuring delivery. GPT-Live keeps Cedar, because Onyx is not one of its voices, and *hey mint* starts a session on supported clients; Telegram and Discord use voice notes instead. The voice at home speaks with the same Onyx voice, set in Home Assistant's OpenAI text-to-speech entry together with a short prompt for tone, pacing and a Brazilian accent. Hermes has no setting for that prompt, so it lives only in Home Assistant.

```yaml
stt:
  provider: openai
  openai:
    model: gpt-4o-transcribe
```

```yaml
tts:
  provider: openai
  openai:
    voice: onyx
```

```yaml
voice:
  voice_chat_mode: gpt-live
  gpt_live:
    voice: cedar
```

```yaml
wake_word:
  enabled: true
  provider: sherpa
  phrase: "hey mint"
```

### 🔊 Voice at home

A Home Assistant voice satellite lets Bárbara talk to Mint out loud at home, with the same soul, memory and integrations he has in chat. Home Assistant runs in the lab, handles the microphone and speaker through the satellite, and turns speech into text and back with OpenAI. The Hermes Voice integration hands each utterance to Mint's API, so the device holds no intelligence of its own. The lab's multiplexed gateway owns the one API listener and answers for Mint under `/p/mint/`. Home Assistant reaches it over the lab's Docker network at `http://hermes:8642/p/mint/v1`, so nothing is published to the internet.

The API exposes his full toolset, so his own key opens it. Hermes asks for an `API_SERVER_KEY` on every profile that answers, and each profile has its own, long and different from the others: Pepper's key sits in her own `.env`, and Mint's in his. Mint's key is also entered in the Hermes Voice integration in Home Assistant. Spoken conversations get their own session, separate from Telegram and Discord. Hermes Voice keeps one session per conversation by default, and Home Assistant starts a new one after five minutes of silence. The phone and Home Assistant are on different networks, so the satellite is added by its Tailscale address, since ESPHome discovery does not cross networks.

```bash
API_SERVER_KEY=…
```

### 📡 Messaging

Mint gets his own Telegram and Discord bots. Numeric user allowlists restrict who can talk to each bot. Gateway shutdown and restart notices stay out of both chats.

```yaml
platforms:
  telegram:
    enabled: true
    gateway_restart_notification: false
  discord:
    enabled: true
    gateway_restart_notification: false
```

### 🐙 GitHub App

Mint's GitHub App works on Bárbara's repositories under his bot identity, so his changes are distinct from hers. He mints a short-lived installation token for each task; the private key stays in his Hermes profile and reaches the sandbox only as a credential file. [SOUL.md](SOUL.md#github) defines his branch, pull request and merge boundaries.

```bash
GITHUB_APP_ID=…
GITHUB_APP_INSTALLATION_ID=…
GITHUB_APP_PRIVATE_KEY_PATH=/opt/data/profiles/mint/github-app.pem
```

### 📬 Google Workspace

Mint uses the same published Google OAuth client as Pepper, with his own grant and token in his private profile. The Google Workspace skill gives him Gmail, Calendar, Drive, Contacts, Sheets and Docs. The consent screen is In production, so the Testing mode's seven-day refresh-token expiry does not apply.

```bash
/opt/data/profiles/mint/google_client_secret.json   # a private copy of the shared OAuth client
/opt/data/profiles/mint/google_token.json           # Mint's separate account grant
```

### 🏠 Home Assistant

The official Home Assistant plugin lets Mint read and control the smart devices at Bárbara's home, by chat or by voice. His long-lived token belongs to a Home Assistant user created for him, so his access can be narrowed or revoked without touching hers. The plugin refuses service domains that run code on the Home Assistant host, and no events are forwarded to him: the plugin also ships a gateway platform that listens to Home Assistant's event bus, but it forwards nothing until `watch_domains`, `watch_entities` or `watch_all` is set, and none is. Hermes logs a warning about that at startup.

```bash
HASS_URL=http://homeassistant:8123
HASS_TOKEN=…
```

### 🧪 Sandbox

Mint's shell runs in his own Modal account and public image. Hermes copies only his Google and GitHub credential files into each sandbox, keeping them separate from Pepper's.

```yaml
terminal:
  backend: modal
  modal_mode: direct
  modal_image: ghcr.io/petri-hub/mint-sandbox:4dcb772
  credential_files:
    - google_token.json
    - google_client_secret.json
    - github-app.pem
```

### 🔌 MCP servers

Vercel and Notion use their hosted servers, and each gives Mint what the account in its OAuth consent screen can reach. Notion is authorized with Bárbara's own account, so he sees her workspace and never Petri's. Hermes stores both authorizations in Mint's profile, separate from Pepper's; no key for either goes in his `.env`. Notion's hosted server was chosen over the bundled skill because it needs no integration token and no manual page sharing, which would have put a secret in Bárbara's hands and broken silently whenever a page was not shared. It exposes 77 tools, writes included, so [SOUL.md](SOUL.md#constraints--guidelines) holds anything irreversible for her approval.

| Server | What it gives the agent | Link |
|---|---|---|
| `notion` | Pages, databases, comments and meeting notes in Bárbara's workspace | [Notion MCP](https://developers.notion.com/docs/mcp) |
| `vercel` | Projects, deployments and logs available to the authorized account | [Vercel MCP](https://vercel.com/docs/agent-resources/vercel-mcp) |

```yaml
mcp_servers:
  notion:
    url: https://mcp.notion.com/mcp
    auth: oauth
    enabled: true
  vercel:
    url: https://mcp.vercel.com
    auth: oauth
    enabled: true
```

### 🗂️ Session retention

Ended conversations are kept instead of being automatically pruned after 90 days.

```yaml
sessions:
  auto_prune: false
```

### 🧱 Plugins

Langfuse records Mint's turns, model calls and tool use in the shared Hermes project under the `mint` environment, so the agents can be filtered apart. The lab enables full capture, including prompts, replies and tool payloads.

| Plugin | What it gives the agent | Link |
|---|---|---|
| `langfuse` | Traces, sessions, usage and cost in the shared Hermes project | [Official Langfuse plugin](https://github.com/NousResearch/hermes-official-plugins/tree/main/langfuse) |
| `homeassistant` | The `ha_list_entities`, `ha_get_state`, `ha_list_services` and `ha_call_service` tools | [Official Home Assistant plugin](https://hermes-agent.nousresearch.com/docs/plugins/homeassistant) |

```yaml
plugins:
  enabled:
    - langfuse
    - homeassistant
```

```bash
HERMES_LANGFUSE_PUBLIC_KEY=…
HERMES_LANGFUSE_SECRET_KEY=…
HERMES_LANGFUSE_BASE_URL=https://us.cloud.langfuse.com
HERMES_LANGFUSE_ENV=mint
```

### ⏱️ Wakapi

The lab's `wakapi-mint` reporter sends Mint's activity to his own Wakapi user every five minutes, separate from Pepper's stats.

## References

- [Environment variables](.env.example): every variable Mint needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to him, in the words it was asked for
- [Soul](SOUL.md): who he is, how he talks and the rules he follows
