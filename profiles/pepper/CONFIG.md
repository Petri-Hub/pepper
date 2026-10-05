# 🐦 Pepper

> Petri's general-purpose assistant, and a bird about it. She's sarcastic, answers in whatever language she's spoken to, and complains once before doing what he asks. She lives on Telegram, Discord and voice, runs reminders, opens PRs across Petri-Hub as her own GitHub App, and works his Gmail, Calendar and Drive. With anyone who isn't Petri, his money, documents, inbox and private repos stay off limits.

## 💬 Platforms

<table>
  <tr>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/telegram" width="48" height="48" alt="Telegram" /><br>Telegram</td>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/discord" width="48" height="48" alt="Discord" /><br>Discord</td>
  </tr>
</table>

## Configuration

### 🧠 Model

OpenAI, because it's the easiest to set up and it runs on prepaid credits: when they run out, Pepper stops, so there's no pay-as-you-go bill that can grow without limit. GPT-6 Luna is a good mid-tier model for almost everything she does, and it gets replaced whenever a better one comes out — which is exactly what happened to GPT-5.6 Luna, beaten by its own successor on both score and price.

GPT-5.6 Luna sits behind it as a fallback — not for quality, but because a new model gets a smaller hourly allowance until it earns a bigger one, and Luna runs out sooner than everything else on the account.

```yaml
model:
  provider: openai-api
  base_url: https://api.openai.com/v1
  default: gpt-6-luna
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

Everything voice goes through OpenAI, with the same key as the model, good quality and a fair price. Voice notes on Telegram and Discord are transcribed before Pepper reads them, and when she answers out loud, OpenAI speaks for her, in the *marin* voice. *Cedar* and, before it, Hermes' default *alloy* didn't sound like her, so one voice was picked for both ways she talks: *marin* exists in OpenAI's text-to-speech and in GPT-Live, the model behind her live conversations. In Hermes' CLI, TUI and desktop app she can also hold those live conversations, listening while she talks, and a wake phrase opens a session without touching anything. Those last two don't work on Telegram or Discord. Her live voice is Hermes' own default for that mode, so the YAML leaves it out.

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
```

### 🐙 GitHub App

Pepper works on GitHub as herself, through an App called *Pepper, Petri's Bot*, installed on the Petri-Hub account across every repository. Her commits and pull requests show up under the bot's name instead of Petri's, so it's always clear who did what.

There's no personal token and no login to keep alive: for each task she mints one that lasts about an hour and can be narrowed to the single repository she is touching. The key itself lives inside her Hermes home, mounted read-only by the lab, so it travels with her into a sandbox.

Which repositories she may merge on her own, and which stop at a pull request for Petri to review, is part of her personality rather than her configuration, and lives in [SOUL.md](SOUL.md#the-repositories).

```bash
GITHUB_APP_ID=…
GITHUB_APP_INSTALLATION_ID=…
GITHUB_APP_PRIVATE_KEY_PATH=/opt/data/github-app.pem
```

### 📬 Google Workspace

Pepper reads and writes Petri's Gmail, Calendar and Drive, and reaches Contacts, Sheets and Docs along the way. Hermes has no toolset for any of it — it ships a skill she drives herself — so nothing is enabled here and nothing is mapped by the lab. What makes it work is an OAuth client of Petri's own and a token beside her other files, profile-scoped so a second agent signs in as itself.

While the consent screen is on "Testing", the token expires about once a week, and it has to be renewed in her own container, since a token written inside a sandbox is lost with it. That is kept on purpose: publishing the consent screen removes the expiry, but a leaked token would then stay valid for months, and hers is copied into every sandbox. The skill takes all of its scopes at once, so Google's consent screen is the only place to hand over less. What she may send, attach and share lives in [SOUL.md](SOUL.md#what-never-leaves).

```bash
/opt/data/google_client_secret.json   # the OAuth client, downloaded from Google Cloud
/opt/data/google_token.json           # her token, refreshed automatically
```

### 🎵 Spotify

Pepper can play, pause, queue and search music, and read and edit playlists and the library, through Hermes' own Spotify tools. They run on a Spotify developer app of Petri's, signed in once with his account, and they only work with a Premium account and a device that is open, like his phone. They are on for Telegram, Discord and her scheduled runs, and off everywhere else. Her scheduled runs matter because the morning report checks that Spotify is connected, and Hermes leaves Spotify out of a cron run unless it is asked for by name. The report only needs to list devices, but the toolset also plays and queues, and that run reads email and GitHub text, so the report should touch nothing else.

Turning the toolset on made Hermes write out the full tool list for those platforms instead of the `hermes-telegram` and `hermes-discord` bundles, so a tool Hermes adds later will not reach them on its own. The cron list is her current cron tools plus `spotify`, checked beforehand so that Notion, Miro, Sentry, Vercel and Canva stayed in.

```yaml
platform_toolsets:
  telegram: [browser, clarify, code_execution, …, spotify, …]
  discord:  [browser, clarify, code_execution, …, spotify, …]
  cron:     [browser, clarify, code_execution, …, spotify, …]
```

The app's redirect URI is `http://127.0.0.1:43827/spotify/callback`, and its token is renewed by Hermes itself. The Client ID is saved with that token in her data folder, so there is no variable for it.

### 📦 Modal

Her shell commands run in a disposable Modal sandbox rather than inside her own container, so a build that goes wrong burns a cloud VM instead of the laptop the lab runs on. Hermes itself does not move: only the terminal does. Modal's free tier stops rather than bills when it runs out, which is the same reason OpenAI was picked.

Her credentials and skills travel into each sandbox and nothing she writes there comes back, so anything worth keeping goes to a repository or a message before the command ends. The token pair is profile-scoped, so a second agent brings its own Modal account.

The sandbox runs [her own image](sandbox/), built from this repository and public because Modal pulls it without credentials. It carries the libraries her skills need, the tools to render video, and Claude Code, Codex and OpenCode, so she can hand coding work to an agent signed in as Petri instead of spending her own tokens. Their work reports to Wakapi under her own user, as machine `pepper`, so it never counts in Petri's stats, and to ai-memory. Claude Code is the one signed in today; Codex and OpenCode are installed without a login.

The image holds no secrets. Each one is a file in her data folder, which Hermes copies into every sandbox. The GitHub key and the Google files are listed here too: the skills ask for them, but only this list gets them there reliably.

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

```
/opt/data/sandbox/credentials/claude-code-oauth-token   # from claude setup-token, valid for a year
/opt/data/sandbox/credentials/wakapi-url                # https://lab-wakapi.petri.zip/api
/opt/data/sandbox/credentials/wakapi-api-key            # her own Wakapi user's key, so her time stays out of his stats
/opt/data/sandbox/credentials/ai-memory-url             # https://lab-ai-memory.petri.zip
/opt/data/sandbox/credentials/ai-memory-auth-token      # the lab's ai-memory token
```

### 🩹 Patches to Hermes

Two faults in Hermes' own code stopped her sandbox from working properly: a file she made there never reached the chat, and her file tools hung until they timed out. Each has a patch, kept on her data folder in `patches/`, and the lab runs a boot script that applies them every time the container starts. The image is `:latest`, so without the script a rebuild would bring both faults back; a patch that no longer fits a newer Hermes is skipped and named in the boot log, never forced.

```yaml
# the lab's compose, in the hermes service
volumes:
  - ./configuration/03-apply-patches:/etc/cont-init.d/03-apply-patches:ro
```

### ✍️ File tools

Her file tools write into the Modal sandbox, not into her container, so Hermes' guard that limits them to `/opt/data` was checking the wrong filesystem and only denied her own scratch folders. It is switched off, and the credential and session files stay protected on their own. Their content travels inside one command, so a file over roughly 64 KB fails, and her personality tells her to build a big one in the terminal.

```yaml
# the lab's compose, in the hermes service
environment:
  - HERMES_WRITE_SAFE_ROOT=
```

### 🔌 MCP servers

Notion, Vercel, Sentry, Canva and Miro, each as the vendor's own hosted server. Every one is authorized as Petri in the browser, so each vendor's consent screen is where he chooses what it may see, and none needed an app of his own.

Vercel is the one to be careful with: it can spend his money and read production secrets. Nothing is turned off here, because the restraint belongs in her personality — [SOUL.md](SOUL.md#what-costs-money) forbids the purchases outright.

| Server | What it gives the agent | Link |
|---|---|---|
| `notion` | Pages and databases from Petri's Notion workspace | [Notion MCP](https://developers.notion.com/docs/mcp) |
| `vercel` | Deployments, logs, projects and domains | [Vercel MCP](https://vercel.com/docs/mcp) |
| `sentry` | Issues, events, stack traces and Seer analysis | [Sentry MCP](https://docs.sentry.io/product/sentry-mcp/) |
| `canva` | Designs, folders, brand templates, assets and comments | [Canva MCP](https://www.canva.dev/docs/mcp/) |
| `miro` | Boards, spaces and frames, read and write | [Miro MCP](https://developers.miro.com/docs/connecting-to-miro-mcp) |

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
```

### 🧱 Plugins

ai-memory is her long-term memory, the same wiki Claude Code writes to on every machine Petri codes on, so she remembers what was decided in any repository and not only what was said to her. Before each reply she searches it and gets the top matches in context, and each conversation is sent back to it when it ends. The search covers the whole wiki, work projects included, and that was a deliberate choice. It runs in every conversation, his friends' included, and [SOUL.md](SOUL.md)'s list of what is his alone doesn't name ai-memory yet.

She reaches it on the lab's internal network rather than its public address. It's a community plugin with no license, pinned to the commit that was read before installing it.

| Plugin | What it gives the agent | Link |
|---|---|---|
| `ai-memory` | Wiki context before every reply, turns and session ends sent to ai-memory, and `ai_memory_search`, `ai_memory_write` and `ai_memory_status` tools | [ai-memory-hermes-plugin](https://github.com/MrLuciano/ai-memory-hermes-plugin) |

```yaml
memory:
  provider: ai-memory
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

She also has five official skills from Hermes' catalog, installed on purpose and not made from chat: `excalidraw` for hand-drawn diagrams, `pixel-art` for retro art, `pr-lens` for animated diagrams of code changes, and `hyperframes` and `brag` for videos. The two video skills need Node, FFmpeg and a headless Chrome, which her sandbox image carries.

```bash
hermes skills install official/creative/excalidraw
hermes skills install official/creative/pixel-art
hermes skills install official/software-development/pr-lens
hermes skills install official/creative/hyperframes
hermes skills install official/creative/brag
```

## References

- [Environment variables](.env.example): every variable Pepper needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to her, in the words it was asked for
- [Soul](SOUL.md): who she is, how she talks and the rules she follows
