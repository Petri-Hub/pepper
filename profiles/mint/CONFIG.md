# 🌿 Mint

> Mint is a separate assistant being prepared for Telegram, Discord and voice. He will use OpenAI for conversation and speech, and his own Modal sandbox for commands. His personality is deliberately minimal until the live profile is working; no other accounts or integrations are connected.

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

Mint streams replies, shows his reasoning, and can react to a message when a full reply is unnecessary.

```yaml
display:
  show_reasoning: true
  streaming: true
  message_reactions: true
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

Mint gets his own Telegram and Discord bots. Numeric user allowlists restrict who can talk to each bot.

```yaml
platforms:
  telegram:
    enabled: true
  discord:
    enabled: true
```

### 🧪 Sandbox

Commands run in Modal under Mint's own token pair. Direct mode selects that account instead of a managed sandbox.

```yaml
terminal:
  backend: modal
  modal_mode: direct
```

### 🔌 MCP servers

None yet.

### 🧱 Plugins

None yet.

## 🚧 Not connected yet

OpenAI · Modal · Telegram · Discord

The live Mint profile has not been created. Each service needs its own credentials, and Pepper's gateway must serve Mint before either bot can answer.

## References

- [Environment variables](.env.example): every variable Mint needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to him, in the words it was asked for
- [Soul](SOUL.md): who he is, how he talks and the rules he follows
