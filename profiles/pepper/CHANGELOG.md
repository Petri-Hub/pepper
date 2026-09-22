# 🐦 Pepper · Changelog

Newest first. Each entry is the ask in plain words, and what it became.

### 2026-09-22 · A SOUL without Petri's personal life

> *Temporarily remove my personal information from the SOUL. Generalize her without knowledge of me — I'm thinking about making her public, and she'll understand me through other means that won't live in this repository.*

The persona, voice, trust model, git workflow and prompt-injection rules stay. What's gone is everything about Petri's life: his background, his current situation and plans, his routine, the people close to him by name, the list of repositories and their merge policy, and the names that must never be published. In their place, Pepper is told that what she knows about Petri comes from her memory and the conversation, that every repository is PR-only unless he says otherwise, and that she never starts a conversation with anyone but him.

This copy no longer matches the live agent, which still runs the full personal SOUL.

### 2026-09-22 · Replies and checkpoints

> *Add the checkpoints, make the reasoning true (we apply it later on the instance) and the message emojis, the streaming one too.*

Two new sections. Replies covers streaming, visible reasoning and emoji reactions. Checkpoints covers the file snapshots taken before Pepper changes anything. Showing her reasoning is new: the live agent still hides it until the change is applied there.

### 2026-09-22 · The 500-step limit comes back, and the README becomes CONFIG.md

> *Return the 500 max messages configuration. And rename the README.md file to CONFIG.md.*

The cap of 500 steps per message is back, in a section of its own, since Hermes' default is no limit at all and the live agent has run with 500 all along. The profile's description now lives in `CONFIG.md`.

### 2026-09-22 · Configuration moves into the README

> *Let's not duplicate two places about its configuration. Remove the config file and bring it to the README.*

`config.yaml` is gone. Each setting now sits in the README under the section it belongs to, after a short explanation of what it does and why it was chosen. Along the way:

- The model section explains the choice: prepaid OpenAI credits that stop instead of an open-ended bill, and a mid-tier model that covers almost everything
- Reasoning, timezone, transcription, speech, voice chat and wake word each got a section of their own
- GitHub App became its own section, explaining why Pepper has a bot identity and short-lived tokens
- Platforms became a list of icons, without home channels, which don't always exist
- Dropped the crons, behaviour and personality sections. Behaviour settings are about Hermes rather than Pepper, and the personality moved into the description at the top
- Dropped `max_turns: 500`, which wasn't a remembered choice. Hermes' default is unlimited, and the live agent still has the 500 cap

### 2026-09-21 · Baseline

> *Bring Pepper's live configuration into this repo.*

Captured from the running agent. The live `config.yaml` has 218 lines; 17 of them are decisions, and they were kept in `config.yaml`. Everything in [CONFIG.md](CONFIG.md) was already running before this repo existed:

- OpenAI GPT-5.6 Luna as the model, replacing OpenRouter
- Telegram and Discord, each with a home channel
- OpenAI voice: transcription, TTS, live voice chat with the wake word
- GitHub App auth
- SOUL.md at its 20/09/2026 revision
