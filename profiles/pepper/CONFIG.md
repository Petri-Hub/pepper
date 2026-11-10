# 🐦 Pepper

> Petri's general-purpose assistant for reminders, research, coding and everyday tasks. She talks casually with his group in their language, and plainly when something is serious. She works through Telegram, Discord and voice, with her own GitHub App and access to his Google Workspace. She never buys anything or sends something under his name without his review, and keeps his private accounts and documents away from everyone else.

## 💬 Platforms

<table>
  <tr>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/telegram" width="48" height="48" alt="Telegram" /><br>Telegram</td>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/discord" width="48" height="48" alt="Discord" /><br>Discord</td>
  </tr>
</table>

## Configuration

### 🧠 Model

OpenAI's prepaid credits put a limit on model spending. GPT-6 Luna handles everyday work; GPT-5.6 Luna is the fallback when the primary model is unavailable.

```yaml
model:
  provider: openai-api
  base_url: https://api.openai.com/v1
  default: gpt-6-luna
  context_length: 150000
```

```yaml
fallback_model:
  - provider: openai-api
    model: gpt-5.6-luna
```

### 🤔 Reasoning

Medium effort. It's enough for most of what she does, like small coding tasks, research and errands, without making every simple question slow and expensive.

```yaml
agent:
  reasoning_effort: medium
```

### 🗜️ Context compression

Pepper uses a 150,000-token working context window and starts compressing near 85% of its usable input budget, matching Lemon. Output-token reservation can make the trigger lower than 127,500 tokens.

```yaml
compression:
  threshold: 0.85
```

### 🔁 Turn limit

The 500-step cap stops a task that runs away from consuming credits indefinitely.

```yaml
agent:
  max_turns: 500
```

### 🔒 Conversation search

Hermes' `session_search` can read conversations from another profile, so it is disabled across Pepper's chats and scheduled runs to keep the agents' histories separate. Her saved platform tool lists also leave it out; her skills and skill management remain available.

```yaml
agent:
  disabled_toolsets: [session_search]
```

### 🕒 Timezone

São Paulo time, so reminders and scheduled tasks fire at the hour Petri means, not in UTC.

```yaml
timezone: America/Sao_Paulo
```

### 💭 Replies

Replies show up as they're being written instead of all at once, but her reasoning stays hidden on every platform so the chat shows what she says rather than how she arrived at it. She can also react to messages with an emoji when a full reply isn't needed.

```yaml
display:
  show_reasoning: false
  streaming: true
  message_reactions: true
```

### ⏰ Scheduled replies

Her scheduled reports arrive as she wrote them, without Hermes adding a cron title, job ID, separator or footer on any platform.

```yaml
cron:
  wrap_response: false
```

### 🎙️ Voice

OpenAI transcribes voice notes on Telegram and Discord and speaks Pepper's replies in *marin*, the voice Petri chose for both spoken replies and live conversations. GPT-Live and the *hey pepper* wake phrase work in supported CLI, TUI and desktop sessions, not in Telegram or Discord chats. Sherpa recognizes that phrase because it accepts custom text; the desktop app supplies the microphone when Hermes runs in the lab.

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
    voice: marin
```

```yaml
voice:
  voice_chat_mode: gpt-live
```

```yaml
wake_word:
  enabled: true
  provider: sherpa
  phrase: "hey pepper"
```

### 🐙 GitHub App

Pepper works on GitHub as herself, through an App called *Pepper, Petri's Bot*, installed on the Petri-Hub account across every repository. Her commits and pull requests show up under the bot's name instead of Petri's, so it's always clear who did what.

There's no personal token and no login to keep alive: for each task she mints one that lasts about an hour and can be narrowed to the single repository she is touching. The key itself lives inside her Hermes home, mounted read-only by the lab, so it travels with her into a sandbox.

Every change she makes is a branch and a pull request, and she merges only when Petri says so for that one pull request. That rule is part of her personality rather than her configuration, and lives in [SOUL.md](SOUL.md#coding).

```bash
GITHUB_APP_ID=…
GITHUB_APP_INSTALLATION_ID=…
GITHUB_APP_PRIVATE_KEY_PATH=/opt/data/github-app.pem
```

### 📬 Google Workspace

The Google Workspace skill gives Pepper Gmail, Calendar, Drive, Contacts, Sheets and Docs through Petri's own OAuth grant. Its client and renewable token live in her private profile and are copied into her sandbox. The consent screen is In production, and her [SOUL.md](SOUL.md#constraints--guidelines) limits what she may send or share.

```bash
/opt/data/google_client_secret.json   # the OAuth client, downloaded from Google Cloud
/opt/data/google_token.json           # her token, refreshed automatically
```

### 🎵 Spotify

The official Spotify plugin lets Pepper control playback and manage Petri's playlists and library when a Premium account and active device are available. Spotify is enabled in Telegram, Discord and scheduled runs because her morning report checks the connection. These explicit lists also freeze the other toolsets available on each platform.

```yaml
platform_toolsets:
  telegram: [browser, clarify, code_execution, …, spotify, …]
  discord:  [browser, clarify, code_execution, …, spotify, …]
  cron:     [browser, clarify, code_execution, …, spotify, …]
```

### 📦 Modal

Pepper runs shell and file work in a disposable Modal sandbox, isolated from the lab host and paid for by her own Modal account. Her [public image](sandbox/) supplies tools and libraries; Hermes copies only the listed private credential files into it. Work she wants to keep must reach a repository or chat before the sandbox ends. The lab applies a patch for sandbox file delivery; delivery to chat still needs an end-to-end check after the Hermes upgrade.

```yaml
terminal:
  backend: modal
  modal_mode: direct
  modal_image: ghcr.io/petri-hub/pepper-sandbox:45daeb9
  credential_files:
    - sandbox/credentials/claude-code-oauth-token
    - sandbox/credentials/wakapi-url
    - sandbox/credentials/wakapi-api-key
    - sandbox/credentials/ai-memory-url
    - sandbox/credentials/ai-memory-auth-token
    - github-app.pem
    - google_token.json
    - google_client_secret.json
```

```bash
MODAL_TOKEN_ID=…
MODAL_TOKEN_SECRET=…
```

### ✍️ File tools

File tools write in Modal, so the lab clears Hermes' container-local safe root for this backend. Pepper's [SOUL.md](SOUL.md#limitations) tells her to use terminal commands for files too large for a single file-tool call.

```yaml
# the lab's compose, in the hermes service
environment:
  - HERMES_WRITE_SAFE_ROOT=
```

### 🔌 MCP servers

Notion, Vercel, Sentry, Canva and Miro use their hosted MCP servers and Petri's separate OAuth grants. FAM is his read-only portal server, with credentials kept in Pepper's private `.env`. Vercel can affect production and spending, so [SOUL.md](SOUL.md#constraints--guidelines) restricts what she may do with it.

| Server | What it gives the agent | Link |
|---|---|---|
| `notion` | Pages and databases from Petri's Notion workspace | [Notion MCP](https://developers.notion.com/docs/mcp) |
| `vercel` | Deployments, logs, projects and domains | [Vercel MCP](https://vercel.com/docs/mcp) |
| `sentry` | Issues, events, stack traces and Seer analysis | [Sentry MCP](https://docs.sentry.io/product/sentry-mcp/) |
| `canva` | Designs, folders, brand templates, assets and comments | [Canva MCP](https://www.canva.dev/docs/mcp/) |
| `miro` | Boards, spaces and frames, read and write | [Miro MCP](https://developers.miro.com/docs/connecting-to-miro-mcp) |
| `fam` | Grades, assignments, schedule and other data from FAM's student portal, read-only | [FAM MCP](https://github.com/Petri-Hub/fam-mcp) |

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
  sentry:
    url: https://mcp.sentry.dev/mcp
    auth: oauth
    enabled: true
  canva:
    url: https://mcp.canva.com/mcp
    auth: oauth
    enabled: true
  miro:
    url: https://mcp.miro.com/
    auth: oauth
    enabled: true
    tools:
      exclude:
        - diagram_create
        - diagram_get_dsl
        - layout_create
        - layout_get_dsl
        - layout_read
        - layout_update
  fam:
    command: uvx
    args: [--python, "3.14", fam-mcp]
    env:
      FAM_USERNAME: "${FAM_USERNAME}"
      FAM_PASSWORD: "${FAM_PASSWORD}"
```

### 🗂️ Session retention

Ended conversations are kept instead of being automatically pruned after 90 days.

```yaml
sessions:
  auto_prune: false
```

### 🧱 Plugins

Langfuse records Pepper's turns, model calls and tool use in the shared Hermes project under the `pepper` environment, so the agents can be filtered apart. The lab enables full capture, including prompts, replies and tool payloads.

ai-memory is Pepper's long-term wiki. The community plugin recalls context before replies and sends her turns and session endings back to the lab server. Its search covers every project, including private work, even when friends talk to her; this access choice needs separate review if that boundary changes.

| Plugin | What it gives the agent | Link |
|---|---|---|
| `ai-memory` | Wiki context before every reply, turns and session ends sent to ai-memory, and `ai_memory_search`, `ai_memory_write` and `ai_memory_status` tools | [ai-memory-hermes-plugin](https://github.com/MrLuciano/ai-memory-hermes-plugin) |
| `langfuse` | Traces, sessions, usage and cost in the shared Hermes project | [Official Langfuse plugin](https://github.com/NousResearch/hermes-official-plugins/tree/main/langfuse) |
| `spotify` | Playback, search, queue, playlists and library tools | [Official Spotify plugin](https://github.com/NousResearch/hermes-official-plugins/tree/main/spotify) |

```yaml
memory:
  provider: ai-memory

plugins:
  enabled:
    - langfuse
    - spotify
```

```json
{
  "server_url": "http://ai-memory:49374",
  "workspace": "hermes",
  "project": "pepper"
}
```

```bash
AI_MEMORY_AUTH_TOKEN=…
```

```bash
HERMES_LANGFUSE_PUBLIC_KEY=…
HERMES_LANGFUSE_SECRET_KEY=…
HERMES_LANGFUSE_BASE_URL=https://us.cloud.langfuse.com
HERMES_LANGFUSE_ENV=pepper
```

## References

- [Environment variables](.env.example): every variable Pepper needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to her, in the words it was asked for
- [Soul](SOUL.md): who she is, how she talks and the rules she follows
