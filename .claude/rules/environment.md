---
paths:
  - "profiles/**/.env*"
---

# Environment files

## Purpose

> Keep each profile environment example a complete, public-safe checklist of the variables needed for its chosen integrations. This rule governs tracked `.env.example` files; real values stay in ignored local or live profile environments.

## Rules

### ✅ Do

| Rule | Directive |
|---|---|
| **List every required variable** | Mirror each CONFIG integration dependency in `.env.example` — missing names make a fresh setup fail late. |
| **Group by service** | Order service groups like CONFIG, with one brief comment per group — readers can match a variable to the decision that needs it. |
| **Show value shape** | Use recognizable placeholders instead of real values — a setup checklist should reveal expected syntax without publishing a credential. |
| **Use Hermes names** | Name variables exactly as Hermes reads them inside the container — invented names silently leave integrations unconfigured. |

### 🚫 Don't

| Rule | Directive |
|---|---|
| **Avoid secrets in Git** | Don't write real tokens, keys or passwords to a tracked example — public history retains them after deletion; use an ignored `.env` instead. |
| **Avoid generated variables** | Don't list runtime-written or container-wide values as profile choices — the example would misstate what a profile owner must provide. |

## Reference

`profiles/<name>/.env.example` lists every variable the agent needs to run, grouped by what each one connects to. It's the checklist for setting the agent up somewhere new, so a variable missing from it is a bug.

```bash
# OpenAI — model, transcription and speech (same key for both)
OPENAI_API_KEY=sk-proj-...
VOICE_TOOLS_OPENAI_KEY=sk-proj-...

# Telegram — bot token from @BotFather, and who may talk to Pepper
TELEGRAM_BOT_TOKEN=123456789:your-telegram-bot-token
TELEGRAM_ALLOWED_USERS=123456789
```

### Shape

- **One section per service**, in the same order as `CONFIG.md`: the model provider first, then platforms, then integrations.
- **One brief comment above each section**: `# <Service> — what these are for`. No header comment at the top of the file, and no comments on individual lines.
- **Placeholders that show the shape of the value**: `sk-proj-...`, `123456789:your-telegram-bot-token`, `123456789,987654321`. Real non-secret values that are the same everywhere, like a mount path, can stay as they are.

### Names

Variables use the names Hermes reads inside the container, like `OPENAI_API_KEY`. Real values belong in the agent's own `.env`: `/opt/data/.env` for Pepper, Hermes' default profile, and `/opt/data/profiles/<name>/.env` for a named profile. The lab's Compose environment is for container-wide settings, not agent credentials.

So a new profile variable needs an entry here and a value in that profile's live `.env`. Tracked files record only placeholders. A local, gitignored `profiles/<name>/.env` can hold values for manual transfer to the live profile.

### What belongs here

Variables the agent needs because of a choice recorded in `CONFIG.md`: provider keys, bot tokens, allowed users, integration IDs. When a `CONFIG.md` section depends on a variable, the section mentions it and this file holds it.

What doesn't belong:

- **Anything Hermes writes on its own** into the agent's `.env`, like home channels set from chat or terminal and browser timeouts.
- **Container-level settings the lab owns**, like the dashboard's login.

### Secrets

No real value ever enters a tracked file: not here, not in `CONFIG.md`, not in a changelog entry. Never stage or commit a local profile `.env`.

`.env` holds real values and is gitignored. When looking at a live `.env` on the lab, read key names only. To learn whether a key is set, test it without printing it:

```bash
[ -n "$(grep -E '^API_SERVER_KEY=' .env | cut -d= -f2-)" ] && echo set || echo empty
```

## Patterns

### ✅ Correct

```bash
# DeepSeek — Lemon's model
DEEPSEEK_API_KEY=your-deepseek-api-key

# Discord — Lemon's bot and allowed users
DISCORD_BOT_TOKEN=your-lemon-discord-bot-token
DISCORD_ALLOWED_USERS=123456789012345678
```

### 🚫 Wrong

```bash
DEEPSEEK_API_KEY=live-account-key
DISCORD_BOT_TOKEN=live-bot-token
```

> Real credentials in a tracked example are exposed to every repository reader and remain in Git history.
