# 🐦 Pepper · Changelog

Newest first. Each entry is the ask in plain words, and what it became.

### 2026-10-01 · Her ai-memory search gets its parameters back

> *She told me she cannot use the AI memory search call, it doesn't have parameters in that specific tool, so both me and her are really confused... Can you make this fix so maybe she can search my sessions?*

Her `ai_memory_search` and `ai_memory_write` tools reached the model with no parameters, so she couldn't tell what to pass and gave up. `ai_memory_status` kept working because it takes none, which is why the connection looked healthy the whole time.

The cause is in the community plugin: it declares its tools with `input_schema`, Anthropic's key, and Hermes reads `parameters`, as its own providers do. Hermes only checks that a tool has a name, so the mismatch raised no error. The plugin's per-reply prefetch was never affected, since it searches directly.

This is not a permissions problem. ai-memory has no users, only one shared token, and her search is deliberately unscoped, so she reads every project's pages, yours and Claude Code's included. Nothing about that changed. Her own writes still land under workspace `hermes`, project `pepper`.

On the live agent: the three `input_schema` keys in `plugins/ai-memory/provider.py` became `parameters`, with the original beside it as `provider.py.bak-<timestamp>`. The plugin now differs from upstream commit `087e310`, so reinstalling it would bring the bug back. The gateway was restarted so the schemas load.

### 2026-09-29 · ai-memory becomes her long-term memory

> *Can you do that for me please? Feel free to restart it.* — installing the community ai-memory plugin for Hermes, with the search left as shipped.

She now uses [ai-memory](https://github.com/akitaonrails/ai-memory) as her memory provider, through the community [ai-memory-hermes-plugin](https://github.com/MrLuciano/ai-memory-hermes-plugin). Hermes allows one external memory provider at a time and she had none, so nothing was replaced: `MEMORY.md` and `USER.md` stay on beside it. [CONFIG.md](CONFIG.md#-plugins) records the setting, the plugin's own `ai-memory.json`, and the token.

What it does, per conversation: fetches any pending handoff at the start, searches the wiki before each reply and puts the top three snippets in her context, sends each of Petri's messages as an observation, sends the whole conversation when it ends, and mirrors her `MEMORY.md` writes to wiki pages under `hermes-memory/`. Its writes are scoped to workspace `hermes`, project `pepper`.

Its search is not scoped, and that was chosen knowingly over a three-line patch that would have limited it to her own project: she sees every project's memory, work included, in every conversation, the ones with his friends included. SOUL.md's list of what is his alone doesn't name ai-memory yet.

How it was installed, since there is no first-party installer:

- the plugin was read in full first, then copied into `plugins/ai-memory/` at commit `087e310`, rather than through its `curl | bash` script. It has no license and one main author, and it was written against ai-memory 1.28 and Hermes 0.20.5; every endpoint it calls was checked against the lab's ai-memory 2.4.1 before switching
- it talks to `http://ai-memory:49374` on the lab's Docker network, so it doesn't depend on the public address or on the Cloudflare bypass that comes off on 30 September
- `AI_MEMORY_AUTH_TOKEN` went into her own `.env`, beside Modal's tokens, instead of a lab mapping, so it needed no lab change

On the live agent: `memory.provider: ai-memory` in her config, the plugin and its config in her data folder, the token in `.env`, and a gateway restart. `hermes memory status` reports the provider active and available. Backups are beside the files, dated `20260929-095904`. A first conversation will show whether prefetch and the hooks work end to end.

### 2026-09-29 · Her own sandbox image, and Claude Code in it

> *Add Claude Code and Codex installation into her environment, adjust whatever you need in the SBX, and ensure that the image is working as expected: Wakapi, CC, Codex, OpenCode downloaded, AI Memory and Wakapi wired in.*

Her Modal sandbox now runs [an image of her own](sandbox/) instead of Hermes' stock one. It carries the Python libraries her Gmail and GitHub skills used to install on every fresh sandbox, and three coding agents she can delegate to: Claude Code, Codex and OpenCode. [CONFIG.md](CONFIG.md#-modal) records the two new settings, `modal_image` and `credential_files`. It is built from `sandbox/compose.yml` and published to GHCR by the *Publish Pepper Image* workflow on every push to `main` that touches it.

Claude Code signs in with a long-lived OAuth token from `claude setup-token`, so delegated work runs on Petri's Claude subscription instead of her OpenAI allowance. The 25 September roadmap note that Claude Code "does not work" was never true: it had not been tried. It works now, confirmed with her own delegated run.

Secrets reach the sandbox as files, not variables. Hermes passes neither `env_passthrough` nor Modal Secrets to a Modal sandbox, but it does mount `terminal.credential_files`, so each token and URL is a file under `sandbox/credentials/` in her data folder. A script in the image exports them once per session and wires Wakapi and ai-memory into all three agents.

Getting Wakapi to record her work took three fixes:

- `heartbeat_rate_limit_seconds = 0`, since wakatime-cli held heartbeats for two minutes and a sandbox can be gone before then
- one more sync when a Claude Code session ends, since the WakaTime plugin syncs at most once a minute and short jobs never reached it
- two tips in her `claude-code` skill, which told her to use `--no-session-persistence` and `--bare`. The first stops Claude Code from writing the session log that WakaTime reads, and the second skips the plugin and hooks entirely. Both tips now say never. Hermes keeps a skill someone edited through upgrades, so this copy stops receiving upstream changes to that skill.

Her heartbeats go to a Wakapi user of her own, `Pepper`, not to Petri's. His GitHub profile README pulls its numbers from his account's last 30 days, and Wakapi can't exclude a machine from those stats, so a separate user is what keeps her work out of them.

On the live agent: her config gained both settings, her seven stock-image snapshots were cleared so the new image would take over, and the gateway was restarted. The backups are beside the files, dated `20260929-121819` for the skill and `20260928-230733` for the rest.

Still open: Codex needs a `CODEX_ACCESS_TOKEN` and OpenCode a model provider, so neither is signed in. The sandbox reaches ai-memory through its public URL, which loses its Cloudflare bypass on 30 September; after that, her Claude Code runs keep reporting to Wakapi but not to ai-memory until the sandbox has another way in.

### 2026-09-23 · CONFIG.md stops explaining Hermes

> *Some Pepper sections are HUGE, map some of that to the CHANGELOG or something, keep the overall CONFIG.md less descriptive. Too many technical details. This is for a human, a human doesn't want to know about 10000 Modal caveats.*

[CONFIG.md](CONFIG.md) went from roughly 1,450 words of prose to 790. The rule in `.claude/rules/configuration.md` has always said one to three sentences per section, and today's entries quietly broke it: Modal had grown to 279 words, the GitHub App to 272, MCP servers to 269, against Checkpoints at 16 and Voice at 80.

What came out was mechanism. Whether `modal_mode` is pinned to `direct` and why, how the secret scope resolves a profile credential, that `home_mode` already resolves correctly inside a container, the five-second sync interval, which vendors register dynamically and which use a metadata document, Vercel's 212 tools, Miro's six deprecated exclusions, the eight Google scopes by name. None of it is wrong and all of it is in the entries below, which is where a reader who wants it should end up.

What stayed is the shape of a decision: what the thing is, why it was chosen, and the one consequence someone needs to hold in their head. Modal keeps "a build that goes wrong burns a cloud VM instead of the laptop" and "nothing she writes there comes back". The fallback keeps "a new model gets a smaller allowance until it earns a bigger one" without the token arithmetic.

Two corrections fell out of the pass. A sentence about the GitHub key had been inserted twice, and the App was described as installed across "all 16 repositories" when the live installation reports 17 — the count now reads "every repository", since a number in a document nobody recounts is a number that goes stale. `SOUL.md` still lists sixteen by name and is due the same correction in its own rework.

### 2026-09-23 · She learns her way around FAM

> *She also configured the FAM skills, and I've configured the credentials, mark as done.*

Three skills of her own, written by her from the portal rather than from a description of it: `fam-login` signs in with vault credentials, `fam-inbox` finds and summarizes the university's notifications, and `fam-assignements` finds activities by their current status. They live under `productivity/`, like the rest of what she has taught herself.

The credentials are in Hermes' encrypted browser vault, `vault.json.enc` beside its key, not in `.env` and not anywhere near this repository. She reaches them with `browser_vault_list` and `browser_vault_fill`, so the values never pass through a prompt or a log line.

Nothing is recorded here beyond this entry. Skills she writes from chat are runtime state, and a copy kept here would be out of date by the week — the same reason memories and reminders stay out. What the repository holds is that she can do it at all.

Worth knowing for whoever picks this up next: the browser she drives for FAM is the local one inside the container, not the Modal sandbox. It is also the component that wedged the gateway's event loop this evening when its CDP connection died, so a FAM session that hangs is the first place to look.

### 2026-09-23 · A second bucket, after the new model turned out to have a smaller one

> *Let's configure GPT 5.6-luna fallback only for now.*

She stopped mid-task twice tonight, and the cause was the morning's model switch rather than anything she did. Reading the rate-limit headers off Petri's own key: `gpt-6-luna` allows **200,000 tokens a minute**, while `gpt-5.6-luna`, `gpt-6-sol`, `gpt-5.6-terra` and `gpt-6-astra` all allow **500,000**. A new model launches with a reduced ceiling until it earns a higher one. Moving her to GPT-6 Luna cut her throughput by sixty per cent, which the benchmark and the price list gave no hint of.

That ceiling is easier to hit than it looks. Her context sits around 55,000 tokens, and one turn with a few tool calls makes four API calls in twenty-five seconds — roughly 220,000 tokens, over the limit before the minute is out. Prompt caching does not help: the failing calls logged a 100% cache hit and were refused anyway, because caching discounts the bill, not the rate.

The ceiling is per model, so the fix needs no second provider and no second key — just a second bucket. `gpt-5.6-luna` is the entry, chosen over the higher-scoring `gpt-5.6-terra` because it is the model she ran on until this morning and is known-good here. Hermes' own `fallback list` states the trigger: rate limits, 5xx and dropped connections.

Also worth recording, since it was wrong in this repository's head for most of the day: the fallback chain is **not** auth-only. That is a different mechanism in the CLI's start-up path. The runtime chain classifies rate limits as a failover reason and engages after `agent.api_max_retries` (3 by default) is spent, before the auto-recovery ladder.

Applied to the live agent without a restart, since the gateway's cold boot discards Telegram messages queued while it was down — which is how three of Petri's messages disappeared earlier this evening. It takes effect on new sessions.

### 2026-09-23 · The key stops being a copy

> *Shouldn't we have the variable of HERMES_GITHUB_APP_ID to like, HERMES_PEPPER_GITHUB_APP_ID, so HERMES_PEDRO_GITHUB_APP_ID can exist in the future? Why 2 mounts of the secrets?*

Earlier today the GitHub App key was copied into `/opt/data` by hand, because a credential file only reaches a sandbox from inside the Hermes home. A copy of a private key is a thing that goes stale on rotation, so the lab now mounts the same file there instead — [Petri-Hub/lab#6](https://github.com/Petri-Hub/lab/pull/6). One file on disk, two paths, nothing to keep in step.

The second mount is gone with it. `/run/secrets/github-app.pem` only ever served `GITHUB_APP_PRIVATE_KEY_PATH`, which now points at the new location; `skills_hub_github.py` is its only reader, and `mint-token.py` hardcodes its own App and installation identifiers and never reads the environment at all. `CONFIG.md` and `.env.example` follow the variable to its new value.

That PR also committed the deployment as it actually ran. The lab's compose had drifted badly — still naming OpenRouter and Groq, missing every dashboard, OpenAI, Telegram and GitHub App variable the container had been running with, and not included in the apps aggregate at all. The lab-side App identifiers are now `HERMES_PEPPER_GITHUB_APP_ID` and `HERMES_PEPPER_GITHUB_APP_INSTALLATION_ID`, which reads better beside a second agent, though it is naming rather than isolation: the container environment is shared by every profile, and what actually separates them is each profile's own `.env` read through Hermes' secret scope, the same route the Modal tokens take.

`SOUL.md` gained the key too. *What never leaves* named `.env` and `/run/secrets/` but not the private key itself, which was fine while it sat in a directory she never touched and is not fine now that it rides into every sandbox with her; it is listed there and in the injection rules beside them.

Applying it moved the container from the `hermes` compose project to `apps`, which is where the merged `services/apps/compose.yml` now includes it. `make apps-up` is the command.

### 2026-09-23 · She installs what the sandbox is missing

> *Change only the SOUL.md for now, I want to have more time for the actual Docker image, let's make a temporary fix.*

Gmail and the GitHub App were never as broken as they looked. A bare Modal sandbox has no `googleapiclient`, no `jwt` and no `cryptography`, so both scripts die on import — but the credentials and the scripts themselves are already there, and installing the libraries takes seconds. Measured in a live sandbox: `setup.py --install-deps` in five seconds, after which `gmail labels` returns real labels; `pip install PyJWT cryptography` in two, after which `mint-token.py` mints a valid `ghs_` installation token.

So the fix is knowledge, not capability. `SOUL.md` now tells her that a `ModuleNotFoundError` in a fresh sandbox means the libraries are missing and never that the integration is gone, names the two commands, and asks her to run them quietly once per sandbox rather than reporting Gmail or GitHub as down — which would send Petri chasing a problem that is not there.

Hermes re-reads `SOUL.md` on every prompt build, so this needed no restart. The system prompt is composed once per thread, so a conversation already open keeps the old copy until the next session.

Deliberately left alone: `google_api.py` still hardcodes `/opt/data/google-workspace-packages` on line 33, the same bug that `mint-token.py` had with its key path, and it should resolve from `__file__` instead. Fixing it changes nothing on its own, since that directory does not sync into a sandbox either way. Both it and this stopgap go away when she gets an image with the libraries already in it.

### 2026-09-23 · GPT-6 Luna

> *Looks like OpenAI released GPT-6 models, and Luna + Sol prices went 50% cheaper. Can you help Pepper use GPT-6 Luna by default?*

Her model is `gpt-6-luna`. The id was read off OpenAI's own `/v1/models` on Petri's key rather than taken from the announcement, which answers 403 to anything that is not a browser, and a real completion was sent to it before the switch — it came back on `gpt-6-luna` with `finish_reason: stop`. `gpt-6-astra` is also on the account and was not considered.

The case for Luna over Sol is not the halved price, it is that the benchmark puts Luna ahead on both axes at once: 95.5 points against GPT-5.6 Luna's own run, at roughly a twelfth of the cost. Sol went the other way — 91.0 against its predecessor's 100.0, and specifically weaker at noticing disguised vulnerabilities, which is the wrong regression for an agent that reads other people's repositories and other people's email.

Nothing else moved. `reasoning_effort` stays at medium, and nothing about the switch touches the terminal, the MCP servers or her soul.

### 2026-09-23 · What the move to Modal broke, and the soul that never shipped

> *Go ahead and fix things: the GitHub thing, the SOUL.md, the paths fix, etc. Just keep Google out of terminal if the skill is already doing its job.*

A health check run from Telegram found Gmail, Calendar, Drive, Sheets, Docs, Contacts and the GitHub App all failing, every one of them with a path that no longer exists:

```
'/opt/data/skills/productivity/google-workspace/scripts/google_api.py': No such file or directory
'/opt/data/skills/github-app-auth/scripts/mint-token.py': No such file or directory
```

Pepper read that as her tools being absent. They are not. All 68 skills sync into the sandbox, scripts included — `_walk_skill_tree` keeps `scripts/` deliberately — but they arrive under `/root/.hermes/`, not `/opt/data/`. She was calling the container's name for a directory from inside a machine that has never heard of it.

`SOUL.md` now says where she is. Three anchors changed: clones are `~/.hermes/workspace/<repo>` instead of `/opt/data/workspace/<repo>`, her Google token is named home-relative, and the closing paragraph is replaced by *Where your commands actually run* — that she thinks in the container and executes in a Modal sandbox as root at `/root`, that `/opt/data` does not exist there, what travels with her and what does not, and that nothing she writes comes home. Her personality, Petri's life and the repository policy were left untouched; a fuller rework comes later.

**The larger find was that the repository and the live agent had drifted, in the direction that mattered.** The repo copy was 241 lines against the live agent's 216, and everything written over the previous two days had landed here only: the whole `What costs money` section, the Vercel environment-variable rule, the `gmail.send` draft-and-wait rule, the Drive attachment rule and the Notion/Miro line. She had been answering messages with Vercel's `buy_*` family reachable and no rule against calling it. The sync that fixed the paths also, finally, gave her those.

Google needed nothing. The `google-workspace` skill already declares both files in its own `required_credential_files`, so they travel whenever it loads; `terminal.credential_files` stays unset rather than duplicating a working declaration.

GitHub needed three things. A credential file only syncs when it sits inside the Hermes home, and `/run/secrets/` does not, so the key was copied to `/opt/data/github-app.pem`. `mint-token.py` had `/run/secrets/github-app.pem` hardcoded — not read from `GITHUB_APP_PRIVATE_KEY_PATH`, which turned out to be decorative — and now resolves `parents[3] / "github-app.pem"` from its own location, which is `/opt/data` on the host and `/root/.hermes` in a sandbox, with the old path kept as a fallback. The skill declares the key in its frontmatter like Google does, so it gets the same upload-only protection. Verified: the key arrives, the path resolves, and the script still fails on `import jwt`.

That last failure is the one thing neither config nor code can fix here. The stock sandbox image has no `PyJWT`, no `cryptography` and no `googleapiclient`, and the 121 MB of Google libraries under `/opt/data/google-workspace-packages` are not in the sync set and never will be — Hermes syncs credentials and skills, not installed libraries. An image of her own is now on the roadmap, and it unblocks Gmail and GitHub together.

Also: `browser.use_real_profile` is off. It was on with no Chromium in the container, which failed every real-profile page load and predates Modal entirely. `false` is Hermes' own default, so nothing is recorded in [CONFIG.md](CONFIG.md) for it.

Still open: sync-back is broken on this build — `_modal_bulk_download()` reads a binary tar through a text decoder and dies on the first non-UTF-8 byte — and a stray copy of the Google OAuth client is sitting in `attachments/`, which syncs to every sandbox as ordinary content rather than as a protected credential.

### 2026-09-23 · Her terminal moves to Modal

> *I need your help to configure Hermes with Modal, I've already created the account. One important thing: I'm planning to create Pedro, so I think the `home_mode` should be per profile, as Pedro will have overall different credentials.*

Shell commands now run in a Modal sandbox instead of inside the container she lives in. Hermes does not move — the gateway, the model, Google and the five MCP servers stay put — only `terminal.backend` changes, so the lab's laptop stops being the thing that executes whatever she decides to run. Modal's Starter plan is $30 of compute a month that stops rather than bills when no card is on file, which is the same argument that picked OpenAI.

`modal_mode` is pinned to `direct`. Its default, `auto`, prefers Hermes' managed Nous gateway whenever the account is entitled to it, and pinning keeps every sandbox on Petri's own Modal account. Nothing else was recorded: the resource limits in the live `config.yaml` are Hermes' own defaults, so they stay out by the usual rule.

**`home_mode` was left at `auto`, and the ask it came from was answered a different way.** In a container, `auto` already resolves to `{HERMES_HOME}/home` — Pepper's terminal home is `/opt/data/home` — so `profile` would force the path it already uses. It only differs on a bare-metal host, where `auto` keeps the real OS home. Profile isolation does not come from that setting at all: `agent/secret_scope.py` exists so that "each profile's `.env` keys cannot be unioned into `os.environ`", and it fails closed rather than falling back. Modal was built into that deliberately — `has_direct_modal_credentials()` reads the token pair through the secret scope "so the default profile's Modal account never selects the direct backend for a multiplexed secondary". Pedro will get his own Modal account by having his own `.env`, and nothing here has to change for him.

The lab is untouched, which was not the expectation going in. The SDK looked like it needed a new image, since the venv is read-only to the `hermes` user and the deployment sets `HERMES_DISABLE_LAZY_INSTALLS=1` — but that flag only stops Hermes installing on its own, and `hermes_bootstrap.activate_durable_lazy_target()` already puts `/opt/data/lazy-packages` on `sys.path` at startup for exactly this case. `modal==1.3.4`, the version `lazy_deps.py` pins, installs there. The tokens are profile credentials in `/opt/data/.env` rather than a `HERMES_*` compose mapping, which is both what makes them per-profile and why the lab needs no new variable.

Worth knowing about what crosses the wire: credentials, the skills tree and nine cache directories are pushed in and re-pushed every five seconds. At teardown the workspace comes home, but credential files are upload-only, so a token refreshed inside a sandbox is thrown away instead of overwriting hers. Her state — `state.db`, `config.yaml`, `SOUL.md`, `cron/`, `memories/` — never leaves the container.

### 2026-09-23 · Backed up, identity only

> *I care more about WHAT MAKES IT RUN LIKE BEFORE, than THE HISTORY THAT IT PRODUCED.*

Restic now copies Pepper to the lab's pendrive, beside the game saves, every six hours. The set is small on purpose: `SOUL.md`, `config.yaml`, `skills/`, `cron/`, `memories/`, `assets/` and `profiles/`. Roughly four megabytes of the gigabyte under `/opt/data`, and 1.3 MB once stored.

What was left out shaped it more than what went in. Conversations, the kanban and the other SQLite databases hold what she did rather than who she is, and dropping them also meant nothing in the set is a live database, so the job needs no snapshot hook and the container never stops. Every credential stays out too — the five MCP tokens, the Google token and client, the provider pool — because each is re-obtainable by redoing an OAuth flow, and leaving them out keeps the pendrive from being worth stealing.

It is an allow-list rather than a list of exclusions, so a new token or cache file appearing in `/opt/data` is left out by default instead of being quietly swept in. `profiles/` is listed so a second agent is captured without touching the configuration again.

A restore gives back an agent who is herself, remembers Petri, keeps her schedule and knows her rules, with no history and signed out of all six services. The work lives in the lab repository, where it belongs, as [Petri-Hub/lab#5](https://github.com/Petri-Hub/lab/pull/5).

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
