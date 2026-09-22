---
paths:
  - "profiles/**/.env*"
---

# Environment files

`profiles/<name>/.env.example` lists every variable the agent needs to run, grouped by what each one connects to. It's the checklist for setting the agent up somewhere new, so a variable missing from it is a bug.

```bash
# OpenAI — model, transcription and speech (same key for both)
OPENAI_API_KEY=sk-proj-...
VOICE_TOOLS_OPENAI_KEY=sk-proj-...

# Telegram — bot token from @BotFather, and who may talk to Pepper
TELEGRAM_BOT_TOKEN=123456789:your-telegram-bot-token
TELEGRAM_ALLOWED_USERS=123456789
```

## Shape

- **One section per service**, in the same order as `CONFIG.md`: the model provider first, then platforms, then integrations.
- **One brief comment above each section**: `# <Service> — what these are for`. No header comment at the top of the file, and no comments on individual lines.
- **Placeholders that show the shape of the value**: `sk-proj-...`, `123456789:your-telegram-bot-token`, `123456789,987654321`. Real non-secret values that are the same everywhere, like a mount path, can stay as they are.

## Names

Variables use the names Hermes reads inside the container, like `OPENAI_API_KEY`. The lab stores them with a `HERMES_` prefix in `services/apps/hermes/.env` and maps them in `services/apps/hermes/compose.yml`.

So a new variable needs two changes: the entry here, and a mapping in the lab. This repo doesn't touch the lab, so say which `HERMES_*` variable and compose line the lab needs.

## What belongs here

Variables the agent needs because of a choice recorded in `CONFIG.md`: provider keys, bot tokens, allowed users, integration IDs. When a `CONFIG.md` section depends on a variable, the section mentions it and this file holds it.

What doesn't belong:

- **Anything Hermes writes on its own** into the agent's `.env`, like home channels set from chat or terminal and browser timeouts.
- **Container-level settings the lab owns**, like the dashboard's login.

## Secrets

No real value ever enters this repository: not here, not in `CONFIG.md`, not in a changelog entry.

`.env` holds real values and is gitignored. When looking at a live `.env` on the lab, read key names only. To learn whether a key is set, test it without printing it:

```bash
[ -n "$(grep -E '^API_SERVER_KEY=' .env | cut -d= -f2-)" ] && echo set || echo empty
```
