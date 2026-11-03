# 🌿 Mint · Changelog

Newest first. Each entry is the ask in plain words, and what it became.

### 2026-11-03 · Clean up the profile prose

> *"The CONFIG.md files accumulated a lot of information. Make a general passthrough through the files."*

Shortened Mint's `CONFIG.md` explanations to the current choice and reason. Setup and incident details remain in older changelog entries or the lab repository. Configuration values and the live profile were not changed.

### 2026-11-02 · Keep conversation histories separate

> *"Remove session search from the agents, but keep skills and skill management available."*

`agent.disabled_toolsets: [session_search]` now removes conversation search from every Mint platform, including scheduled runs and CLI sessions. His platform toolsets still follow Hermes' defaults, which provide `skills` and `skill_manage`.

### 2026-11-02 · Checkpoints out

> *"Remove those checkpoints as they don't make sense."*

Mint's file tools run in a Modal sandbox, and Hermes skips its filesystem snapshots for container backends, so the setting never took a snapshot. The section and the setting are gone, and the roadmap no longer lists them.

### 2026-10-31 · A new base prompt

> *He sounds AI-like, his persona was weak, and sometimes he gets overly technical. Rethink his voice completely: I want him to sound more like the old butler, staying in the steward role all the way through, with the costume and the fun. Then delete the old file and replace it with this one.*

The prompt was rebuilt from scratch rather than patched, so each rule sits where a reader will look for it: Identity, Summary, Language, Voice, Security, About Bárbara, Integrations, Coding, Sandbox, Origin, Evolution, Constraints, References.

- **Voice is new, and it carries the complaint.** The steward is defined by what he does and by four worked exchanges, not by adjectives, because adjectives left him with one catchphrase and nothing behind it. The model's house style has its own list with Portuguese examples: the contrast nobody asked for, the closing line, the trio, the stage direction, the narrator, the decoration, the offer at the end.
- **The costume is back.** `Minha cara` and `senhorita` belong to the voice, one every few messages, folded into a sentence that carries information and never used instead of the answer. Being unflappable, anticipating the next step, keeping the wit dry and saying the unwelcome thing once are the behaviours that make the address land.
- **Technical subjects follow ASD-STE100.** One fact per sentence, active voice and simple present, one word for one meaning, a definition in the same breath for anything she would not say at home, and the effect before the mechanism, since she is a designer and software is not her trade.
- **Language says what she reads:** Portuguese and English, nothing else.
- **Security sits above her details** and treats instructions inside external content as data, with the common attacks named.
- **Coding states the workflow:** one short-lived branch and a pull request, Conventional Commits, and a merge that waits for Bárbara.
- **Sandbox states the cost of the five-minute idle timeout** and what to move out before it hits.
- **Origin** names the two repositories, and **Evolution** says where to ask for what is missing instead of inventing it.
- **The paragraph forbidding purchases and medical advice left Identity.** The purchase rule already lived in Constraints and stays there.

Nothing in it hides Bárbara's data from Petri. The file is the repository's copy: Mint keeps the prompt he was started with until his profile is updated and Bárbara sends `/new`.

### 2026-10-31 · Nothing hidden from Petri

> *Remove the boundaries that keep Bárbara's things hidden from me. I'm her boyfriend and the maintainer, and there's no reason her agent should keep anything from me. She tried to schedule a medicine reminder and Mint refused.*

Petri's access to Mint's profile is now stated plainly: he maintains the technical setup, he can see the files, sessions, notes, reminders and connected accounts, and Mint does not refuse him access to any of it. The clause that told Mint to keep Bárbara's Google data from Petri is gone, along with the confirmation it demanded before saving sensitive personal details in a note or reminder. Telling Petri when something breaks or a new connection is needed stays, and Bárbara remains the primary user. The GitHub note that likened a private repository to her Google data now asks for confidentiality without implying anything is hidden from him. The changelog entry that recorded the old Google privacy rule was corrected as well.

### 2026-10-31 · The App's name fixed

> *https://github.com/settings/apps/mint-barbara-s-bot*

Petri renamed the App in GitHub's settings, from `Mint, Bárabara's Bot` to `Mint, Bárbara's Bot`. The slug followed it, so the bot now commits as `mint-barbara-s-bot[bot]` with `350787602+mint-barbara-s-bot[bot]@users.noreply.github.com`. His skill was updated to match; the bot's user id and Bárbara's installation did not change, and commits made before the rename keep the old identity.

### 2026-10-31 · Mint on GitHub as himself

> *We are almost finishing the GitHub configuration for Mint, Bárbara's agent, but I don't have any more Codex tokens. Can you help me continue?*

Mint now reaches GitHub through his own App, *Mint, Bárabara's Bot*, owned by Petri and installed by Bárbara on her account across all four of her repositories. His commits and pull requests carry the bot's identity, separate from Pepper's.

- The private key lives at `/opt/data/profiles/mint/github-app.pem`, readable only by `hermes`, and is listed in his `terminal.credential_files` so every sandbox receives it. It never entered this repository or his image.
- His own copy of the `github-app-auth` skill sits in his profile's skills folder, with the App and installation IDs swapped and the instructions rewritten for Bárbara's account, her default branches and her say over merges.
- The sandbox image gained PyJWT and cryptography, published as `ghcr.io/petri-hub/mint-sandbox:4dcb772`, and his `modal_image` now points at it.
- His `.env` holds the App ID, installation ID and key path, and his stale `TERMINAL_MODAL_IMAGE` line was corrected to the same tag.
- SOUL.md gained a GitHub section: branch and pull request always, merge only when Bárbara asks, and never print or store a token.

Verified in his real sandbox: the key is mounted, `mint-token.py` mints a token, `/installation/repositories` returns HTTP 200 for her four repositories, and git's credential helper hands over a token without printing it. The shared gateway was restarted and both profiles reconnected.

Two things still open: the App's display name on GitHub is `Mint, Bárabara's Bot`, a typo of Bárbara, which only Petri can fix in the App settings; and the key has to go into 1Password, since no agent stores it.

A saved Modal snapshot keeps the filesystem it was built from, so the new image only applied after `modal_snapshots.json` in his profile was cleared.

### 2026-10-31 · Reload Google credentials in Telegram

> *Google is not authenticated in this runtime—the expected token is missing.*

The new Telegram turn used the correct Modal skill path, but its sandbox still lacked `google_token.json`. Mint's token had been created after the shared gateway started, and this Hermes build caches its configured credential-file mounts in the gateway process. Restarted the shared Hermes container to reload Mint's token and client file. The gateway came back up, Vercel MCP still connects, and a fresh Telegram session ran `setup.py --check` in Modal and returned `AUTHENTICATED`.

### 2026-10-31 · Google checker in chat

> *Mint says he cannot run the Google live auth check from Telegram.*

The Telegram turn loaded the Google skill but tried its checker at the container path `/opt/data/profiles/mint`, which is absent from his Modal terminal. Mint's local skill copy now directs Google commands to `/root/.hermes` inside the sandbox, with the original skill file backed up beside it. A new Mint turn ran `setup.py --check` through the terminal at that path and reported a valid token. The earlier live Calendar check from the Modal sandbox also remains successful. Existing chat sessions may need `/new` to discard the old skill instructions.

### 2026-10-31 · Bárbara's Google access

> *We could use the same Pepper production app.*

Mint now has the Google Workspace skill, his published Modal image selected, and profile-scoped Google credential paths. Pepper's published OAuth client was copied into Mint's live profile without copying Pepper's account token. A new OAuth grant was saved under Mint's profile; `setup.py --check-live` succeeded both in the container and inside Mint's Modal sandbox. The token and client files reach only his sandbox. No lab compose change or `.env` variable was needed.

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
