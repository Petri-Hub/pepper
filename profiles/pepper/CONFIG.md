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

GPT-5.6 Luna stays on as the fallback, for a reason that has nothing to do with quality. A new model launches with a reduced token-per-minute ceiling until it earns a higher one, so GPT-6 Luna allows 200,000 tokens a minute where everything else on the account allows 500,000 — and a single turn with a handful of tool calls can spend that in twenty-five seconds. The ceiling is per model, so the fallback is a second bucket on the same key rather than another provider to sign up for. Hermes reaches for it when the primary is rate-limited, answers 5xx or drops the connection.

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

Since her terminal moved to Modal, the key has to travel with her: a credential file only syncs into a sandbox when it sits inside her Hermes home, and `/run/secrets/` does not. The lab mounts the same file read-only at `/opt/data/github-app.pem`, and the `github-app-auth` skill declares it the way the Google skill declares its own, so it is pushed into every sandbox and never written back. One file on disk under two paths, so rotating the key cannot leave a stale copy behind. `mint-token.py` resolves it from its own location, which lands on `/opt/data` on the host and `/root/.hermes` in a sandbox.

A fresh sandbox has no `PyJWT`, so the first mint inside one installs it first — a couple of seconds. That is behaviour rather than configuration and lives in [SOUL.md](SOUL.md#what-you-can-reach), and it goes away once she has an image with the library already in it.

```bash
GITHUB_APP_ID=…
GITHUB_APP_INSTALLATION_ID=…
GITHUB_APP_PRIVATE_KEY_PATH=/opt/data/github-app.pem
```

### 📬 Google Workspace

Pepper reads and writes Petri's Gmail, Calendar and Drive, and reaches Contacts, Sheets and Docs along the way. Hermes has no toolset for any of it: it ships a bundled skill, `google-workspace`, that she drives from her terminal. So nothing here is enabled in the configuration and nothing is mapped by the lab — what makes it work is an OAuth client of Petri's own, created as a Desktop app in Google Cloud, and a token she holds beside her other files.

The skill asks for all of its scopes at once — `gmail.readonly`, `gmail.send`, `gmail.modify`, `calendar`, `drive`, `contacts.readonly`, `spreadsheets` and `documents` — because this build has no flag to narrow them. Google's consent screen is the only place to hand over less, and the skill accepts a partial grant. Her token is profile-scoped, so a second profile authorizes on its own rather than inheriting hers, and it refreshes without asking. Both files sit in `/opt/data`, which the lab already mounts, so they survive a restart.

What she may send, attach and share is a matter of her personality rather than her configuration, and lives in [SOUL.md](SOUL.md#what-never-leaves).

```bash
/opt/data/google_client_secret.json   # the OAuth client, downloaded from Google Cloud
/opt/data/google_token.json           # her token, refreshed automatically
```

### 📦 Modal

Her terminal runs in a Modal sandbox instead of inside the container. Hermes itself does not move — the gateway, the model calls, Google, the five MCP servers all stay where they are — only shell commands do, so a build that goes wrong burns a disposable cloud VM instead of the laptop the lab runs on. Modal's Starter plan gives $30 of compute a month and simply stops when it runs out as long as no card is on file, which is the same reason OpenAI was picked over a pay-as-you-go provider.

`modal_mode` is pinned to `direct` rather than left at `auto`. Auto prefers Hermes' managed Nous gateway whenever the account happens to be entitled to it, and pinning it keeps every sandbox on Petri's own Modal account, where the spend is his to see. The resource limits are Hermes' own defaults and stay out of here; at one core and 5 GB she would have to run about 350 hours in a month to reach the free ceiling.

The token pair is a profile credential, read through Hermes' secret scope rather than the container's environment, so a second profile brings its own Modal account instead of inheriting hers. It lives in the profile's own `.env` and needs nothing from the lab. `home_mode` stays at `auto`, which inside a container already resolves to the profile's own home.

Credentials, the skills tree and the cache directories are pushed into the sandbox and re-pushed every five seconds as they change. Almost nothing comes back: at teardown the workspace syncs home, but credential files are upload-only, so a token refreshed inside a sandbox is discarded rather than written back over hers.

```yaml
terminal:
  backend: modal
  modal_mode: direct
```

```bash
MODAL_TOKEN_ID=…
MODAL_TOKEN_SECRET=…
```

### 🔌 MCP servers

Notion, Miro, Vercel, Sentry and Canva, all as the vendors' own hosted servers, all from Hermes' approved catalog. Notion also ships as a bundled skill and the skill lost: it wants an integration token in the environment, and every page has to be connected to it by hand, with an unconnected page answering 404 as though it did not exist. The hosted servers authorize as Petri in the browser instead, and each vendor's consent screen is where he chooses what it may see.

None of them needed an OAuth app of his own. Notion, Sentry and Canva identify Hermes with a client metadata document; Miro and Vercel register it dynamically. Miro's six excluded tools are the ones Miro itself deprecated, dropped by the catalog entry rather than by choice. Every token lives in `/opt/data/mcp-tokens/`, profile-scoped like the Google one, and no vendor here offers the device-code flow, so authorizing each one meant pasting the redirect URL back into an interactive session.

Their tools are deferred rather than loaded up front. Hermes' tool search replaces them with `tool_search`, `tool_describe` and `tool_call`, so a schema arrives when it is wanted instead of riding along in every request.

Vercel is the one to be careful with. Its 212 tools include a `buy_*` family that charges Petri's card the moment it runs, tools that read project and shared environment variables in plain text, and one that mints a link bypassing authentication. None of that is turned off here, because the restraint belongs in her personality rather than her configuration: [SOUL.md](SOUL.md#what-costs-money) forbids the purchases outright and treats Vercel's variables the way it treats `/run/secrets/`.

| Server | What it gives the agent | Link |
|---|---|---|
| `notion` | Pages and databases from Petri's Notion workspace | [Notion MCP](https://developers.notion.com/docs/mcp) |
| `miro` | Boards, spaces and frames, read and write | [Miro MCP](https://developers.miro.com/docs/connecting-to-miro-mcp) |
| `vercel` | Deployments, logs, projects and domains | [Vercel MCP](https://vercel.com/docs/mcp) |
| `sentry` | Issues, events, stack traces and Seer analysis | [Sentry MCP](https://docs.sentry.io/product/sentry-mcp/) |
| `canva` | Designs, folders, brand templates, assets and comments | [Canva MCP](https://www.canva.dev/docs/mcp/) |

```yaml
mcp_servers:
  notion:
    url: https://mcp.notion.com/mcp
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
```

### 🧱 Plugins

None yet. · [Plugins](https://hermes-agent.nousresearch.com/docs/user-guide/features/plugins)

## References

- [Environment variables](.env.example): every variable Pepper needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to her, in the words it was asked for
- [Soul](SOUL.md): who she is, how she talks and the rules she follows
