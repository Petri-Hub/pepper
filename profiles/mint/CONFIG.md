# 🌿 Mint

> Mint is Bárbara's concise, polished personal assistant, with the manner of a refined butler and a little chocolate-mint wit. He helps with everyday questions, design discussions and reminders on Telegram, Discord and voice, thinks with OpenAI, and runs commands in his own Modal sandbox. Vercel is connected for her apps; calendar access is not connected yet.

## 💬 Platforms

<table>
  <tr>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/telegram" width="48" height="48" alt="Telegram" /><br>Telegram</td>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/discord" width="48" height="48" alt="Discord" /><br>Discord</td>
  </tr>
</table>

## Configuration

### 🧠 Model

OpenAI with GPT-6 Luna, the same starting model as Pepper. GPT-5.6 Luna is the fallback when the main model is unavailable; Mint uses his own API key for both.

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

Medium effort, matching Pepper's starting point for everyday questions and tasks.

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

### 🕒 Timezone

Americana follows São Paulo time, so reminders and other scheduled work use the local hour.

```yaml
timezone: America/Sao_Paulo
```

### 💭 Replies

Mint streams replies and can react to a message when a full reply is unnecessary. His reasoning, tool progress bubbles and long-running status updates stay out of every chat. Messages sent while he is busy still reach him, but he sends no busy acknowledgment; Pepper continues to acknowledge hers. The installed Hermes version otherwise reads `busy_ack_enabled` as a process-wide setting, so the lab reapplies a profile-aware patch at `/opt/data/patches/hermes-mint-busy-ack.patch` on container boot. After a Hermes update, check whether it handles this setting per profile before retiring or rebuilding the patch.

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

### ⏪ Checkpoints

Hermes snapshots files before Mint changes them, so a mistake can be rolled back.

```yaml
checkpoints:
  enabled: true
```

### 🎙️ Voice

OpenAI transcribes voice notes and speaks Mint's replies in Cedar. GPT-Live also uses Cedar for live conversations, while `hey mint` is the wake phrase on supported clients; Telegram and Discord use voice notes and spoken replies rather than GPT-Live or wake-word sessions.

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

### 🧪 Sandbox

Commands run in Modal under Mint's own token pair. Direct mode selects that account instead of a managed sandbox.

```yaml
terminal:
  backend: modal
  modal_mode: direct
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

The lab's separate `wakapi-mint` reporter reads only Mint's Hermes profile and sends his activity to his own Wakapi user every five minutes. Its sync state and API key stay separate from Pepper's; the key lives in the lab's ignored Wakapi environment file.

## 🚧 Not connected yet

Calendar

Mint can offer reminders and prepare event details, but cannot read or change a calendar until a calendar service is connected.

## References

- [Environment variables](.env.example): every variable Mint needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to him, in the words it was asked for
- [Soul](SOUL.md): who he is, how he talks and the rules he follows
