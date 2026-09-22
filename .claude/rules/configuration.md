---
paths:
  - "profiles/**"
  - "README.md"
---

# Profile documents

Every profile is a folder under `profiles/<name>/`, and `profiles/pepper/` is the reference: when in doubt, match it.

```
profiles/<name>/
├── CONFIG.md       # who the agent is and every setting that makes it so
├── CHANGELOG.md    # every change, in the words it was asked for
├── SOUL.md         # personality and rules, exactly as the agent reads it
├── .env.example    # every variable it needs, with placeholders (see environment.md)
└── avatar.png      # the image it uses on Telegram, Discord and anywhere else
```

There is no `config.yaml`. The settings live in `CONFIG.md`, next to the reason they exist, so there is one place to read and nothing to keep in sync.

## CONFIG.md

```markdown
# <emoji> <Name>

> Who the agent is, in a few plain sentences: its personality, where it lives, what it does and what it won't do.

## 💬 Platforms

<icon table>

## Configuration

### 🧠 Model
### 🤔 Reasoning
### 🔁 Turn limit
### 🕒 Timezone
### 💭 Replies
### ⏪ Checkpoints
### 🎙️ Voice
### <emoji> <Integration>      # one section per integration, like 🐙 GitHub App
### 🔌 MCP servers
### 🧱 Plugins

## 🚧 Not connected yet

## References
```

Keep the order. Leave out a Configuration section when the agent doesn't change anything there. MCP servers and Plugins always stay, with "None yet." when empty, so the gap is visible.

### The description

A blockquote under the title, written as prose. It carries the personality, since there is no separate Personality section: how the agent talks, what it's for, and the lines it doesn't cross. No code formatting, no table, no list.

### Platforms

Its own top-level section, before Configuration. Only the platform names with their icons, no text around them:

```html
<table>
  <tr>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/telegram" width="48" height="48" alt="Telegram" /><br>Telegram</td>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/discord" width="48" height="48" alt="Discord" /><br>Discord</td>
  </tr>
</table>
```

Check that an icon URL loads before using it. Home channels, allowed users and other per-chat details don't go here.

### Configuration sections

Each section is a short description, then the YAML that produces it, and nothing after the code block.

- **The description says what and why.** One to three sentences, and the why is the owner's reason for the choice, not what the feature is in general. "Prepaid credits that stop instead of an open-ended bill" is a reason; "OpenAI is an AI provider" is not.
- **Only settings someone chose.** Hermes merges this YAML over its built-in defaults, so a key that equals its default is left out, and so is anything Hermes writes on its own (`_config_version`, `onboarding`, `platform_toolsets`). The one exception is a default the owner wants back after the live agent overrode it: record it, and say in the changelog that the live agent still has to be changed.
- **Ask instead of guessing.** A setting the owner doesn't remember choosing gets asked about, not recorded. Before calling something a default, check it against Hermes' docs or source.
- **Say where a feature doesn't work.** If a setting only takes effect in the CLI, TUI or desktop app, or only on some platforms, the description says so.
- **One feature, one section.** When a feature spans several top-level keys, like voice across `stt`, `tts`, `voice` and `wake_word`, write one summarized description and then one code block per key, in sequence, without subheadings.
- **Integrations with their own identity get their own section**, explaining what the agent can do there and why it's set up that way. Their env vars go in a `bash` block with `…` as values.
- **No doc links or notes under code blocks.** Links belong in References, or in the "None yet." line of an empty section.

Hermes-wide concerns that aren't about this agent stay out: gateway internals, update behaviour, logging. Crons created from chat are runtime state and aren't documented; a cron that is part of the agent's job gets described where it belongs.

### MCP servers and Plugins

Empty: `None yet. · [MCP](https://hermes-agent.nousresearch.com/docs/user-guide/features/mcp)`. With entries, a table:

| Server | What it gives the agent | Link |
|---|---|---|

### Not connected yet

The services the agent is expected to use but can't yet, as one line of names separated by `·`, and a sentence saying the agent knows they're missing.

### References

Always the same three links:

```markdown
- [Environment variables](.env.example): every variable <Name> needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to <it/her/him>, in the words it was asked for
- [Soul](SOUL.md): who <it/she/he> is, how <it/she/he> talks and the rules <it/she/he> follows
```

## CHANGELOG.md

```markdown
# <emoji> <Name> · Changelog

Newest first. Each entry is the ask in plain words, and what it became.

### YYYY-MM-DD · Short title

> *The ask, in Petri's own words, lightly cleaned up.*

What changed, in prose or a short list. Mention anything dropped, and anything the live agent still has to catch up on.
```

Every change to `CONFIG.md`, `SOUL.md` or `.env.example` gets an entry. Existing entries are history: fix a broken link in them, but don't rewrite what they say.

## SOUL.md

Copied from the live agent byte for byte, and edited here only when the change is also going to the live agent. It is the agent's own file, so it's written to the agent, not to someone reading the repository.

## avatar.png

The agent's picture, the same one its bots use on every platform. Square PNG. Hermes doesn't read it from this folder; it's kept here so the image lives with the rest of the agent.

## The root README

Adding a profile also adds a row to the Profiles table in the root `README.md`:

```markdown
| <emoji> | [<Name>](profiles/<name>/CONFIG.md) | What it is, in a few words | <Provider> | <Platforms, separated by ·> |
```

Name the provider, not the model: the model changes, the provider rarely does. Link straight to `CONFIG.md`, since GitHub only renders a folder's README on its own.
