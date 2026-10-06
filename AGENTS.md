# Pepper — Agent Guide

This repository describes the [Hermes](https://hermes-agent.nousresearch.com/docs/) agents that run in Petri's homelab. The [lab](https://github.com/Petri-Hub/lab) runs the container: image, ports, resource limits and secrets. This repository records what runs inside it, one folder per agent: who the agent is, why each setting was chosen, and the settings themselves.

The reader is a person, not a deploy script. Someone opening a profile should understand what the agent does, where it talks and why, without knowing Hermes.

## Structure

```
.
├── .claude/rules/
│   ├── configuration.md  # how a profile's documents are written
│   └── environment.md    # how .env.example is written
├── assets/               # the How it works diagram, as .excalidraw and .svg
├── profiles/
│   └── <name>/
│       ├── CONFIG.md     # who the agent is and every setting, with the reason for it
│       ├── CHANGELOG.md  # every change, in the words it was asked for
│       ├── SOUL.md       # personality and rules, as the agent reads them
│       ├── .env.example  # every variable it needs, with placeholders
│       └── avatar.png    # its picture on every platform
├── README.md             # the repository's front page and the list of profiles
└── AGENTS.md
```

The rules in `.claude/rules/` hold the details of each document. This file holds what applies everywhere.

## Where the agents live

All profiles run in one container, `hermes`, on the lab host.

| Profile | Home inside the container |
|---|---|
| `pepper` | `/opt/data`, since she is Hermes' default profile |
| any other | `/opt/data/profiles/<name>` |

To reach it, Tailscale must be on Petri's **personal** account. The work account can't see the lab, and SSH simply times out.

```bash
tailscale switch personal
ssh lab
docker exec hermes <command>
```

The lab's own repository is not edited from here. When a change needs something there, like a new `HERMES_*` variable or a compose mapping, say exactly what and leave it to Petri.

## Principles

**Record decisions, not files.** Hermes fills most of an agent's configuration with defaults. Only what someone chose is written down, next to the reason it was chosen. A shorter description that produces the same agent is the goal.

**Check, don't remember.** Before recording a setting, compare it with the live agent. Before calling something a default or saying what a feature does, check Hermes' docs or its source in the container. Say plainly when something could not be verified.

**The live agent is in use.** Reading from it is fine. Changing it, restarting it or writing to its files needs Petri's go-ahead first, every time.

**No credentials, ever.** Tokens, API keys, private keys, password hashes and session secrets never enter this repository, in any file. Identifiers are fine: chat IDs, user IDs, an App ID. When looking at a live `.env`, read key names only, never values.

**The repository is public.** Anyone can read `Petri-Hub/pepper` and its whole history, so nothing personal enters it: not Petri's routine, where he lives, his finances or his family, not what his private repositories hold, not former employers or clients, and not the people close to him, who are never named. Write "a friend" or "his friends" instead. What an agent needs to know privately lives in its memory on the live agent, not in `SOUL.md`. A new commit cannot take a slip back, because the history keeps it, so check before committing.

**One branch.** `main` is the only branch, and commits land on it directly. This is documentation for one reader, not software with releases to stage, so a `develop` branch or a long-lived feature branch only adds a merge to do later. A pull request is for when Petri asks for one.

**Things that move fast stay out.** Skills, memories and reminders created from chat change every day and are managed by Hermes itself. A copy here would always be out of date.

## Changing a profile

1. Understand the ask, and ask back when it's unclear which setting it means.
2. Check the current state on the live agent.
3. Update `CONFIG.md`: the section, its reason and its YAML, following `.claude/rules/configuration.md`.
4. If a variable is involved, update `.env.example` following `.claude/rules/environment.md`, and name the lab mapping it needs.
5. Add an entry at the top of the profile's `CHANGELOG.md`, with the ask in Petri's words.
6. If the change also has to reach the live agent, say so, and apply it only once Petri agrees.

## Adding a profile

1. Create `profiles/<name>/` with the five files, using `profiles/pepper/` as the model.
2. Copy `SOUL.md` from the live profile, if it already exists.
3. Add a row to the Profiles table in the root `README.md`.
4. Start the changelog with the profile's first entry.
