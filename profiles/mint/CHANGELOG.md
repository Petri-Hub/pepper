# 🌿 Mint · Changelog

Newest first. Each entry is the ask in plain words, and what it became.

### 2026-10-28 · Pepper's baseline and a Cedar voice

> *Use a GPT-5.6 fallback, medium reasoning, 500 max turns, Americana/São Paulo time, Pepper's display and checkpoints, and the same voice setup with Cedar instead of Marin.*

Mint's planned settings now include Pepper's fallback model, reasoning level, turn cap, timezone, reply display, checkpoints, OpenAI transcription and GPT-Live. Cedar is selected for both spoken replies and live voice, with `hey mint` as the wake phrase. His local, gitignored `.env` now uses his own OpenAI key for voice too; no live profile was changed.

### 2026-10-28 · First scaffold

> *Mint's avatar is in Downloads. He will use OpenAI and Modal, talk on Discord and Telegram, and have no other connections for now. Use Pepper's model, and keep the SOUL minimal until everything is working.*

Mint's folder now has a real PNG avatar, a short SOUL, the planned profile settings and placeholders for seven environment variables. No real credentials were added, and no live profile, bots or sandbox were configured. The default gateway still has multiplexing disabled; serving Mint alongside Pepper is part of the later live setup.
