# 🐦 Pepper

> Petri's general-purpose assistant, and a bird about it. She's sarcastic, answers in whatever language she's spoken to, and complains once before doing what he asks. She lives on Telegram, Discord and voice, runs reminders, and opens PRs across Petri-Hub as her own GitHub App. With anyone who isn't Petri, his money, documents, inbox and private repos stay off limits.

## 💬 Platforms

<table>
  <tr>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/telegram" width="48" height="48" alt="Telegram" /><br>Telegram</td>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/discord" width="48" height="48" alt="Discord" /><br>Discord</td>
  </tr>
</table>

## Configuration

### 🧠 Model

OpenAI, because it's the easiest to set up and it runs on prepaid credits: when they run out, Pepper stops, so there's no pay-as-you-go bill that can grow without limit. GPT-5.6 Luna is a good mid-tier model for almost everything she does, and it gets replaced whenever a better one comes out.

```yaml
model:
  provider: openai-api
  base_url: https://api.openai.com/v1
  default: gpt-5.6-luna
```

### 🤔 Reasoning

Medium effort. It's enough for most of what she does, like small coding tasks, research and errands, without making every simple question slow and expensive.

```yaml
agent:
  reasoning_effort: medium
```

### 🔁 Turn limit

A single message can take Pepper at most 500 steps, like tool calls and searches, before she stops. Hermes has no limit by default, and a cap keeps a task that went wrong from quietly burning through the credits.

```yaml
agent:
  max_turns: 500
```

### 🕒 Timezone

São Paulo time, so reminders and scheduled tasks fire at the hour Petri means, not in UTC.

```yaml
timezone: America/Sao_Paulo
```

### 💭 Replies

Replies show up as they're being written instead of all at once, with Pepper's reasoning visible next to them, so it's easy to follow what she's doing and why. She can also react to messages with an emoji when a full reply isn't needed.

```yaml
display:
  show_reasoning: true
  streaming: true
  message_reactions: true
```

### ⏪ Checkpoints

Before Pepper changes files, Hermes takes a snapshot, so anything she breaks can be rolled back.

```yaml
checkpoints:
  enabled: true
```

### 🎙️ Voice

Everything voice goes through OpenAI, with the same key as the model, good quality and a fair price. Voice notes on Telegram and Discord are transcribed before Pepper reads them, and when she answers out loud, OpenAI speaks for her. In Hermes' CLI, TUI and desktop app she can also hold live conversations with the *cedar* voice, listening while she talks, and a wake phrase opens a session without touching anything. Those last two don't work on Telegram or Discord.

```yaml
stt:
  provider: openai
  openai:
    model: gpt-4o-transcribe
```

```yaml
tts:
  provider: openai
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
```

### 🐙 GitHub App

Pepper works on GitHub as herself, through an App called *Pepper, Petri's Bot*, installed on the Petri-Hub account across all 16 repositories. Her commits and pull requests show up under the bot's name instead of Petri's, so it's always clear who did what.

There's no personal token and no login to keep alive. For each task she mints a token that lasts about an hour and can be narrowed to the one repository she's touching, so nothing powerful sits around waiting to leak. The App's private key is mounted read-only by the lab.

Which repositories she may merge on her own, and which stop at a pull request for Petri to review, is part of her personality rather than her configuration, and lives in [SOUL.md](SOUL.md#the-repositories).

```bash
GITHUB_APP_ID=…
GITHUB_APP_INSTALLATION_ID=…
GITHUB_APP_PRIVATE_KEY_PATH=/run/secrets/github-app.pem
```

### 🔌 MCP servers

None yet. · [MCP](https://hermes-agent.nousresearch.com/docs/user-guide/features/mcp)

### 🧱 Plugins

None yet. · [Plugins](https://hermes-agent.nousresearch.com/docs/user-guide/features/plugins)

## 🚧 Not connected yet

Gmail · Google Drive · Google Calendar · Notion · Miro · WhatsApp. Pepper knows these are missing and says so rather than improvising.

## References

- [Environment variables](.env.example): every variable Pepper needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to her, in the words it was asked for
- [Soul](SOUL.md): who she is, how she talks and the rules she follows
