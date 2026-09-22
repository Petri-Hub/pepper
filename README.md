<h1 align="center">🐦 pepper</h1>

<br>

<h3 align="center">The workstation for the Hermes agents in my lab.<br>What each one is, what it's wired to, and why</h3>

<p align="center">
  <img alt="Time spent" src="https://img.shields.io/endpoint?url=https%3A%2F%2Flab-wakapi.petri.zip%2Fapi%2Fcompat%2Fshields%2Fv1%2FPetri%2Fproject%3Apepper%2Finterval%3Aall_time&label=time%20spent&logo=wakatime&logoColor=white&color=blue&cacheSeconds=3600" />
</p>

<br>

## About

> **TL;DR:** Pepper is the agent that runs in my [lab](https://github.com/Petri-Hub/lab): she sets reminders and crons, notifies me on Telegram and Discord, and opens PRs on my repos. The lab runs her container. This repo keeps what runs inside it, the personality, the model and every platform she's wired to, written so I can tell what's configured without opening a YAML file.

## How it works

<p align="center">
  <img src="assets/how-it-works.svg" alt="Telegram, Discord and voice reach the Hermes gateway in the lab, which hands every message to Pepper or to another profile. Pepper thinks with OpenAI, works on GitHub through her App and reaches the other lab services. The lab repo runs the container, and this repo describes every profile." />
</p>

Every message, from Telegram, Discord or voice, goes through the Hermes gateway to Pepper, who thinks with OpenAI and works on GitHub and the lab. The lab repository keeps the container running, and this one describes who each profile is.

## Profiles

| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Profile | What it is | Model | Talks on |
|:---:|---|---|---|---|
| 🐦 | [Pepper](profiles/pepper/CONFIG.md) | My general-purpose assistant: reminders, crons, GitHub, research, errands | OpenAI | Telegram · Discord · voice |

## Philosophy

**Decisions, not files.**  
Hermes fills most of an agent's configuration with its own defaults. What's worth keeping is what I actually chose, so everything else stays out. The less configuration it takes to get the same agent, the better.

**Intent over implementation.**  
When I ask for voice transcription in Portuguese, what matters is the provider and the model. The small adjustments made along the way are details, and they only get recorded when they were the point.

**Readable before reproducible.**  
Anyone should be able to open a profile and understand who the agent is, where it talks and why, without knowing Hermes. The configuration comes after the explanation, never instead of it.

**Every change has a story.**  
Each profile keeps a changelog written in the words I used to ask for it, so months later I still know why something is there, and not only that it is.

**The lab owns the body, this repo owns the mind.**  
The container, the ports and the secrets belong to the lab. Here lives who each agent is: the personality, the model, the platforms and how it behaves.

**What moves fast stays out.**  
Skills, memories and reminders change every day, and Hermes takes care of them on its own. Keeping them here would only produce a copy that's always out of date.

**No credentials.**  
Only placeholders. The real values live in the lab and never reach this repository.

## What's inside

```sh
├── .claude/rules      # how agents write profiles and .env files here
├── assets             # the diagram, as an editable Excalidraw file and its SVG
├── profiles
│   └── pepper
│       ├── .env.example   # the variables she needs, with placeholders
│       ├── CHANGELOG.md   # every change, in the words I asked for it
│       ├── CONFIG.md      # what's configured, and why, with the settings that do it
│       └── SOUL.md        # who she is, and the rules she follows
└── AGENTS.md          # the conventions for working in this repository
```

## Technologies

| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Technology | Used for |
|:---:|---|---|
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/hermes-agent.svg" width="20" height="20" alt="" /> | [Hermes](https://hermes-agent.nousresearch.com/docs/) | The agent framework from Nous Research that every profile runs on, with memory, skills, crons and messaging built in |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/openai-light.svg" width="20" height="20" alt="" /> | [OpenAI](https://platform.openai.com/docs) | The model Pepper thinks with, and the voice she listens and speaks with |
| <img src="https://cdn.simpleicons.org/telegram" width="20" height="20" alt="" /> | [Telegram](https://core.telegram.org/bots) | Where I talk to Pepper day to day, and where her reminders reach me |
| <img src="https://cdn.simpleicons.org/discord" width="20" height="20" alt="" /> | [Discord](https://discord.com/developers/docs) | Where Pepper hangs out with my friends, and where they can ask her things too |
| <img src="https://cdn.simpleicons.org/github/9198A1" width="20" height="20" alt="" /> | [GitHub](https://docs.github.com/en/apps) | Where Pepper works on my repositories through her own GitHub App, always through pull requests |
| <img src="https://cdn.simpleicons.org/docker" width="20" height="20" alt="" /> | [Docker](https://docs.docker.com/) | The container in the lab that Pepper lives in |

## Roadmap

What's already in place:

- ✅ Hermes running in the lab, in a container of its own
- ✅ OpenAI as the model provider, replacing OpenRouter
- ✅ Telegram, where I talk to her day to day
- ✅ Discord, where my friends can talk to her too
- ✅ Voice, so she understands voice notes, answers out loud and holds live conversations
- ✅ Her own GitHub App, working on my repositories through pull requests
- ✅ Crons and reminders, delivered to Telegram or Discord
- ✅ A personality, with rules on who she trusts and what she never shares
- ✅ This repository, keeping her configuration readable

What comes next:

- ❌ Gmail, to read, sort and draft email
- ❌ Google Calendar, to know my schedule and plan around it
- ❌ Google Drive, to find and read my documents
- ❌ Notion
- ❌ Miro
- ❌ WhatsApp, as one more place to talk to her
- ❌ Backups of her memory and conversations, next to the game saves the lab already protects
- ❌ Quiet hours, so her messages respect my routine

## References

- [Hermes Agent](https://hermes-agent.nousresearch.com/docs/): the documentation for the framework every profile runs on
- [Hermes Agent on GitHub](https://github.com/NousResearch/hermes-agent): the source code, from [Nous Research](https://nousresearch.com)
- [OpenAI API Platform](https://platform.openai.com/docs): the models behind Pepper's thinking, transcription and voice
- [Telegram Bot API](https://core.telegram.org/bots/api): how Pepper's Telegram bot talks to Telegram
- [Discord Developer Portal](https://discord.com/developers/applications): where Pepper's Discord bot is registered
- [GitHub Apps](https://docs.github.com/en/apps): how Pepper gets her own identity on GitHub
- [Docker](https://docs.docker.com/): what runs Pepper's container in the lab
- [lab](https://github.com/Petri-Hub/lab): the homelab that hosts her
