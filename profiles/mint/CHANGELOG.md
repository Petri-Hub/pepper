# 🌿 Mint · Changelog

Newest first. Each entry is the ask in plain words, and what it became.

### 2026-10-28 · Clear roles and reminders

> *The reminders are shared? What does that mean? You can mention my name, and do we need a separate maintainer paragraph in the identity?*

Petri is named once under boundaries instead of taking space in Mint's identity. The SOUL now distinguishes shared visibility of Mint's note and reminder lists from delivery: reminders normally go to the chat that created them. Pepper has a separate store.

### 2026-10-28 · A person behind the profile

> *You can place some small information about Bárbara. Mint's prompt feels less personal than Pepper's; check how hers is written.*

Mint now knows Bárbara by her first name, her UI/UX work, her timezone and the kind of everyday help she wants. His SOUL has a short section about her, modeled on Pepper's personal context without copying its length. More personal background stays out of this public repository.

### 2026-10-28 · A refined everyday assistant

> *Use elegant vocabulary and a bit of everything in a fancy-butler, chocolate-mint voice. Offer practical next steps, especially notes and reminders, and give a short summary, options and a recommendation when helpful. I maintain the technical side.*

Mint's SOUL now gives him a concise, polished voice and an action-oriented reply style without making every answer a checklist. It distinguishes his primary user from the technical maintainer, explains that Mint's notes are shared within his profile, and forbids access to other profiles' data. It tells him to offer notes and reminders without creating unasked commitments. Calendar access is recorded as pending; he must not claim to manage it yet. His Telegram and Discord bots have both been tested in conversation.

### 2026-10-28 · Live in the lab

> *When I come back we bring the agent to life.*

Created Mint as an empty Hermes profile in the lab, copied his private environment and SOUL, and applied the settings documented here. Pepper's default gateway now serves both profiles. Mint's Telegram and Discord adapters connected, his OpenAI key reached both selected models, and a disposable sandbox ran successfully in his separate Modal workspace. The bots still need a human conversation to verify replies in each app.

### 2026-10-28 · Pepper's baseline and a Cedar voice

> *Use a GPT-5.6 fallback, medium reasoning, 500 max turns, Americana/São Paulo time, Pepper's display and checkpoints, and the same voice setup with Cedar instead of Marin.*

Mint's planned settings now include Pepper's fallback model, reasoning level, turn cap, timezone, reply display, checkpoints, OpenAI transcription and GPT-Live. Cedar is selected for both spoken replies and live voice, with `hey mint` as the wake phrase. His local, gitignored `.env` now uses his own OpenAI key for voice too; no live profile was changed.

### 2026-10-28 · First scaffold

> *Mint's avatar is in Downloads. He will use OpenAI and Modal, talk on Discord and Telegram, and have no other connections for now. Use Pepper's model, and keep the SOUL minimal until everything is working.*

Mint's folder now has a real PNG avatar, a short SOUL, the planned profile settings and placeholders for seven environment variables. No real credentials were added, and no live profile, bots or sandbox were configured. The default gateway still has multiplexing disabled; serving Mint alongside Pepper is part of the later live setup.
