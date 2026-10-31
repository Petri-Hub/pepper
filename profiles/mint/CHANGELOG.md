# 🌿 Mint · Changelog

Newest first. Each entry is the ask in plain words, and what it became.

### 2026-10-31 · Reload Google credentials in Telegram

> *Google is not authenticated in this runtime—the expected token is missing.*

The new Telegram turn used the correct Modal skill path, but its sandbox still lacked `google_token.json`. Mint's token had been created after the shared gateway started, and this Hermes build caches its configured credential-file mounts in the gateway process. Restarted the shared Hermes container to reload Mint's token and client file. The gateway came back up, Vercel MCP still connects, and a fresh Telegram session ran `setup.py --check` in Modal and returned `AUTHENTICATED`.

### 2026-10-31 · Google checker in chat

> *Mint says he cannot run the Google live auth check from Telegram.*

The Telegram turn loaded the Google skill but tried its checker at the container path `/opt/data/profiles/mint`, which is absent from his Modal terminal. Mint's local skill copy now directs Google commands to `/root/.hermes` inside the sandbox, with the original skill file backed up beside it. A new Mint turn ran `setup.py --check` through the terminal at that path and reported a valid token. The earlier live Calendar check from the Modal sandbox also remains successful. Existing chat sessions may need `/new` to discard the old skill instructions.

### 2026-10-31 · Bárbara's Google access

> *We could use the same Pepper production app.*

Mint now has the Google Workspace skill, his published Modal image selected, and profile-scoped Google credential paths. Pepper's published OAuth client was copied into Mint's live profile without copying Pepper's account token. A new OAuth grant was saved under Mint's profile; `setup.py --check-live` succeeded both in the container and inside Mint's Modal sandbox. The token and client files reach only his sandbox, and the live SOUL now keeps Bárbara's Google content private from Petri's technical access. No lab compose change or `.env` variable was needed.

### 2026-10-31 · His own sandbox image

> *First we need a SBX image and publishing. Help me with that.*

Added a small image under `sandbox/` with the Google Workspace skill's pinned Python libraries and a separate GitHub Actions workflow. It published `ghcr.io/petri-hub/mint-sandbox:cb30ede` and `:latest`; the versioned image was pulled anonymously and its Google imports passed. The image contains no credentials. Mint's live profile still uses Hermes' stock Modal image, and Google authorization remains pending.

### 2026-10-31 · Vercel over MCP

> *Help me make Mint's Vercel MCP connection. You can base it on Pepper's.*

Installed Vercel's hosted MCP in Mint's live Hermes profile and completed browser OAuth for that profile, separate from Pepper's authorization. `hermes -p mint mcp test vercel` connected and discovered 238 tools. CONFIG.md records the endpoint and OAuth setting, the README marks the roadmap item done, and SOUL.md adds purchase, secret and production-change boundaries for the new access. No Vercel API key or `.env` variable was needed.

### 2026-10-30 · A less scripted voice

> *Check the humanizer skill and Wikipedia's signs of AI writing, then put some of those principles in Mint's SOUL so he sounds less AI-like.*

Mint's SOUL now asks for direct answers, varied sentence rhythm and details from the conversation instead of stock openings, generic praise and repeat-the-point closers. Lists, summaries and recommendations are used when they help rather than as a fixed reply template. His butler tone remains subtle, and notes or reminders are offered when they solve a real loose end. The guidance draws on [Wikipedia's signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) and the local humanizer skill. The live SOUL was updated to match this file.

### 2026-10-30 · Optional ADHD response mode

> *Install `i-have-adhd` on Mint, and forget about `i-am-burned-out`.*

Installed the upstream `i-have-adhd` skill in Mint's Hermes profile only, at commit `1ecea1993b7fce257ffbd686c070948b5e07eda6`. Hermes' security scan allowed it, and the enabled skill appears in Mint's list but not Pepper's. It is invoked with `/i-have-adhd` rather than changing his normal style by default. The `i-am-burned-out` idea was removed from the roadmap without being marked done.

### 2026-10-30 · His own Wakapi activity

> *Mint has his own Wakapi user; add a job beside Wakapi like Pepper's, then merge and bring up the service.*

The lab now runs `wakapi-mint` against Mint's own Hermes profile and Wakapi account, with a separate sync state and a five-minute Ofelia job. His API key is kept in the lab's ignored environment file, outside this repository. A manual sync succeeded, and Wakapi recorded 19 heartbeats for Mint under machine `mint`. The README now shows a separate card updated from his Wakapi account by the same nightly workflow as Pepper's.

### 2026-10-30 · Silent busy messages for Mint

> *Keep Pepper stating busy acknowledgments, and Mint not.*

Mint now sets `display.busy_ack_enabled: false`, so he accepts messages during a run without sending the automatic busy reply. Pepper keeps the normal acknowledgment. This Hermes version reads that switch process-wide, so the shared gateway has a profile-aware source patch at `/opt/data/patches/hermes-mint-busy-ack.patch`; the lab reapplies it on container boot. A focused check confirmed the setting resolves to false for Mint and true for Pepper. The shared gateway was restarted and is running again.

### 2026-10-30 · Quieter chats

> *Mint needs a harsher cleanup: no thinking, cronjob wrapping, steering messages, “Working 5 min” messages or gateway shutdown messages on any platform. Remove the tool progress bubble too.*

The live Mint profile now hides reasoning, steering acknowledgments, long-running status updates and tool progress bubbles on every platform. Steering and medium reasoning still work; only their chat presentation changes. Cron deliveries now send Mint's response without Hermes' title, job ID, separator and footer. Telegram and Discord have shutdown and restart notices disabled. The settings were read back from his profile, and the shared gateway was restarted to load the platform settings. Both Telegram adapters reconnected; no chat or cron run was triggered just to test the message appearance.

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
