# 🐦 Pepper · Changelog

Newest first. Each entry is the ask in plain words, and what it became.

### 2026-09-22 · Canva, over MCP

> *Help me connect the Canva MCP, it's configured in Claude Code already.*

The fifth MCP server, and the least eventful. `hermes mcp install canva` wrote the block in [CONFIG.md](CONFIG.md), the browser flow ran in a held-open session on the lab, and `hermes mcp test canva` connects in under a second and a half with 34 tools. Canva identifies Hermes with a client metadata document, so nothing had to be pinned.

Worth recording because it is the counterexample: unlike Google's servers, Canva answers an unauthenticated `tools/list` with a `401`. There is no version of this where the login looks like it worked and the calls quietly time out.

The consent screen asked for sixteen scopes, and the write half is broad: `design:content:write`, `folder:write`, `brandtemplate:content:write`, `asset:write`, `comment:write`. Nothing there spends money or reads a secret, so no new section in `SOUL.md` — but it gained a paragraph saying a design he made is his work, so she does not restyle, rename or reorganize one on her own initiative, and that a quiet edit to a brand template propagates to everything built on it.

### 2026-09-22 · A shorter roadmap

> *Remove the WhatsApp necessity from the roadmap. Remove the Customization thing. Remove the profiles thing there too.*

Three items left the README roadmap: WhatsApp, customization and personalization, and more profiles beside her. What remains is backups and plugins.

WhatsApp was also the last name in `CONFIG.md`'s *Not connected yet*, so that section is gone, and `.claude/rules/configuration.md` now says the section is dropped when nothing is pending rather than carrying a "None yet" line like MCP servers and Plugins do — an empty waiting list has nothing to say.

Her `SOUL.md` kept the behaviour and lost the list. The old line named WhatsApp and told her to say a thing was not wired up instead of improvising; it now says that about any tool she does not have, which is what it was really for.

### 2026-09-22 · Vercel and Sentry, and a rule about money

> *We configured the Vercel MCP, can you update the overall documents we have? Also, help me configure Sentry MCP please.*

Vercel was set up elsewhere and read back from the live agent rather than taken on description. Sentry was installed here the same way as the others, and authorized in a held-open session on the lab. Both are in [CONFIG.md](CONFIG.md) now. Sentry connects in under two seconds with 9 tools, most of them reading — issues, events, stack traces, Seer — plus `update_issue`. Its scopes are wider than that surface suggests: `org:read`, `project:write`, `team:write`, `event:write`.

Vercel is the one worth the paragraph. It exposes 212 tools, and reading the whole list turned up three things nobody had asked about. Eight of them buy: `buy_pro`, `buy_credits`, `buy_addon`, `buy_domain` and their variants, charging his card when they run. Several read project and shared environment variables in plain text. One, `get_access_to_vercel_url`, mints a link that bypasses authentication.

None of it is disabled, because the restraint belongs in her personality. `SOUL.md` gained a section, *What costs money*: she never calls a `buy_*` tool, she fetches the quote and hands him the link, and this is the single place where a refusal is real with Petri too — everywhere else her "no" is theater, and the file now says so explicitly. *What never leaves* gained a matching rule putting Vercel's environment variables on the same footing as `/run/secrets/`.

The `❌ MCP servers` line in the README roadmap is also gone, having been true for about an hour.

### 2026-09-22 · Miro, over MCP

> *Help me connect Miro MCP please.*

The same route as Notion, and a smoother one. `hermes mcp install miro` wrote the `mcp_servers.miro` block recorded in [CONFIG.md](CONFIG.md) and applied the catalog entry's own exclude list of six tools — `diagram_create`, `diagram_get_dsl` and the four `layout_*` — which Miro has deprecated or is about to. That list came from the manifest, not from a decision here.

Miro registers Hermes dynamically rather than through a metadata document, and asked for `boards:read`, `boards:write`, `openid` and `email`. Like Notion it has no device-code flow, so the browser flow ran in a held-open session on the lab and the redirect URL went back into it. `hermes mcp test miro` connects in under three seconds and finds 45 tools.

`SOUL.md` now names both MCP services together, in what she can reach and in what is Petri's alone, since she can create, move and delete boards and spaces as easily as she can read them.

### 2026-09-22 · Notion, over MCP

> *Let's go with the MCP route for Notion. Can you configure it for me?*

Notion ships both ways in Hermes: a bundled skill and a catalog MCP entry. The MCP won because the skill needs `NOTION_API_KEY` in the environment — which would have meant a new `HERMES_*` variable and a compose mapping in the lab — and because every page has to be connected to the integration by hand, with an unconnected page answering 404 rather than saying it is not shared. The hosted server needs neither.

`hermes mcp install notion` was run on the live agent, after backing up `config.yaml`. It wrote the `mcp_servers.notion` block now recorded in [CONFIG.md](CONFIG.md), and installed with no tool filter, so `hermes mcp configure notion` is worth running once the tools load. `.env.example` did not change: the token goes to `/opt/data/mcp-tokens/notion.json`, not a variable.

Two things were checked rather than assumed. Notion does **not** advertise device authorization, so `--flow device` fails and the browser flow with a pasted-back redirect URL is the only way in. And Google Drive's registration bug does not apply here — Hermes identifies itself with a client metadata document, so nothing has to be pinned.

Authorized the same evening, with the browser flow and a pasted-back redirect URL. The token landed at `/opt/data/mcp-tokens/notion.json`, and `hermes mcp test notion` connected in about two seconds and discovered 45 tools. `SOUL.md` moved Notion into what she can reach and added it to what is Petri's alone, since she can now write there as well as read, and a write in Notion is closer to a git push than to a note.

All 45 tools are enabled, and that costs less than it looks. Hermes' tool search defaults to `auto` and defers MCP tools, swapping them in the model-visible list for `tool_search`, `tool_describe` and `tool_call` so a schema is fetched when it is needed. What rides along is a name-and-description listing, capped at the smaller of 5% of the context and 4000 tokens. Pruning with `hermes mcp configure notion` is a matter of taste, not a fix.

### 2026-09-22 · Gmail, Calendar and Drive

> *Give her Gmail, Calendar and Drive access. Full Workspace access — use the default `all` service set.*

Hermes has no toolset for Google. It ships a bundled skill, `google-workspace`, already sitting in her skills folder, which she drives from her terminal — so there was nothing to enable in the configuration and nothing for the lab to map. Petri created a Desktop OAuth client in Google Cloud, enabled the Gmail, Calendar, Drive, Sheets, Docs and People APIs, and Pepper ran the setup herself over chat.

`CONFIG.md` gained a Google Workspace section. `.env.example` did not change: the skill reads `google_client_secret.json` and `google_token.json` out of `/opt/data`, which the lab already mounts, instead of any variable. The `all` set turned out to be the only set this build offers — `setup.py` has no `--services` flag, though `SKILL.md` documents one — so Google's consent screen is the only place to hand over less.

Two things went into `SOUL.md` rather than here. Sending email got a rule of its own, since `gmail.send` puts drafting and sending one keystroke apart, and permission to send now covers one message instead of the conversation. Drive got another: a file she may not quote is a file she may not attach, upload or hand someone a link to.

The granted scopes were not checked against the live agent, which was unreachable when this was written. `--check-live` will confirm them, and the section needs correcting if anything was deselected on the consent screen.

### 2026-09-22 · The real SOUL comes back

> *It was a test we did in the past, copy the ACTUAL running SOUL.md to here, and then we make changes.*

The generalization from earlier today is reverted. `SOUL.md` is again a copy of the live agent's, 216 lines against the 141 of the stripped version, so the repository and the running agent stop drifting apart.

That puts Petri's personal life back into the repository: his background and his situation, his routine, the people close to him by name, the repositories and their merge policy, and the list of what must never be published. It is safe only because `Petri-Hub/pepper` is private, which is now written down as a principle in `AGENTS.md`. Making the repository public would expose all of it through the git history, so it comes out before that happens, not after.

### 2026-09-22 · The default profile is called Pepper

> *Make Pepper a profile, and make the default profile her. There will probably be more profiles in the future.*

Hermes' default profile can't be renamed or turned into a named one, so it got a display name instead: `hermes profile rename default Pepper`, applied on the live agent. Hermes now shows her as "Pepper (default)". She stays at `/opt/data` with her history, crons and memory, and future profiles go under `/opt/data/profiles/<name>`. Moving her into a real `pepper` profile was left out, since it would lose her conversation history and change the lab's compose file.

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
