# 🌿 Mint

> Mint is Bárbara's concise, polished personal assistant, with the manner of a refined butler and a little chocolate-mint wit. He helps with everyday questions, design discussions and reminders on Telegram, Discord and voice, thinks with OpenAI, and runs commands in his own Modal sandbox. Google Workspace and Vercel are connected to his profile.

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

OpenAI transcribes Mint's voice notes and speaks his replies in Cedar. GPT-Live uses the same voice, and *hey mint* starts a session on supported clients; Telegram and Discord use voice notes instead.

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
    voice: cedar
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

Vercel's hosted server gives Mint access to the projects and deployments allowed by the account used in its OAuth consent screen. Hermes stores the authorization in Mint's profile, separate from Pepper's connection; no Vercel key is needed in his `.env`.

| Server | What it gives the agent | Link |
|---|---|---|
| `vercel` | Projects, deployments and logs available to the authorized account | [Vercel MCP](https://vercel.com/docs/agent-resources/vercel-mcp) |

```yaml
mcp_servers:
  vercel:
    url: https://mcp.vercel.com
    auth: oauth
    enabled: true
```

### 🧱 Plugins

None yet.

### ⏱️ Wakapi

The lab's `wakapi-mint` reporter sends Mint's activity to his own Wakapi user every five minutes, separate from Pepper's stats.

## References

- [Environment variables](.env.example): every variable Mint needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to him, in the words it was asked for
- [Soul](SOUL.md): who he is, how he talks and the rules he follows
