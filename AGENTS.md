# Pepper — Agent Guide

> Pepper is the public record of the Hermes agents in Petri's lab: Pepper, Mint and Lemon. Each profile explains who the agent is, what it can do and why its settings were chosen. This repository holds their profiles, personalities and sandbox images; the lab repository runs the containers, networking, backups and secret mounts.

## Working in this repository

Start with the relevant profile and the root README. Keep the profile documents and README aligned when a change affects more than one of them. Use this repository as the starting point for configuration work. Check the live agent when the task depends on its current state, a deployment result or a suspected mismatch; a routine documentation change does not need a live comparison.

## Live agent access

Pepper, Mint and Lemon run as Hermes profiles in Petri's homelab. The lab host is reachable over Tailscale SSH, so use that connection to inspect the running agent when live state matters. The [lab repository](https://github.com/Petri-Hub/lab) owns the host and container setup.

## Pull request workflow

Prepare a configuration PR as the complete proposed state. The profile, environment example, changelog and README should describe the intended working setup together, as though the PR were ready to become the record of that setup. Do not leave an integration in the open roadmap or describe it as a temporary plan solely because the PR is awaiting review, credentials or live deployment. Be clear about any live result that has not been verified yet.

After Petri gives the OK, apply the configuration to the running agent and verify it there. A restart or container recreation still needs the separate confirmation described below. If the live setup reveals a missing setting, activation step or documentation change, add it to the same PR and verify again. Merge the PR only when the live configuration works and the repository describes what is running. If verification cannot be completed, leave the PR open and report what is blocking it.

## Structure

```text
.
├── .claude/rules/        # guidance for profile documents and the README
├── .github/workflows/   # sandbox image publishing and Wakapi cards
├── assets/              # diagrams and other README assets
├── profiles/
│   └── <name>/
│       ├── CONFIG.md     # chosen settings and their reasons
│       ├── CHANGELOG.md  # why the profile changed
│       ├── SOUL.md       # the agent's own instructions
│       ├── .env.example  # required variable names and placeholders
│       ├── avatar.png    # the agent's picture
│       ├── sandbox/      # optional development image
│       ├── skills/       # optional repository-managed shared skills
│       └── sync-skills.sh # optional skill deployment helper
├── README.md            # front page and profile roadmaps
└── AGENTS.md            # guidance for working in this repository
```

## Technologies

Hermes runs all three profiles in Docker. Pepper and Mint use OpenAI models and Modal sandboxes; Lemon uses DeepSeek and a dedicated SSH sandbox for Roblox development. MCP connects external tools, AI Memory keeps long-term context, and GitHub Actions publishes sandbox images and refreshes the Wakapi activity cards.

## Constraints and guidelines

- **Protect credentials.** Never expose a real token, key, password or other credential in a tracked file, command output, chat or log. Use variable names and placeholders only. If work needs a real credential, or one appears where it could be exposed, stop and tell Petri what needs attention without repeating its value.
- **Keep personal information private.** This repository is public. Leave out details that feel too personal, and tell Petri what kind of information you filtered. Rewrite or include a detail only after he agrees to the specific public wording.
- **Keep changing state out.** Hermes manages day-to-day skills, memories, reminders and other state that changes through use. Selected shared skills can live here when this repository is their maintained source; applying them replaces the agent's copies.
- **Avoid patching Hermes.** Prefer supported configuration and integrations. If a problem can only be solved by changing Hermes' code, explain the proposed patch and stop until Petri approves it.
- **Confirm restarts.** Before restarting or recreating the running agent or its container, including as a side effect of another change, tell Petri what will be interrupted and wait for his confirmation.

## Related projects

- [lab](https://github.com/Petri-Hub/lab) runs the Hermes container and Lemon's development sandbox.
- [roblox-with-swe](https://github.com/Petri-Hub/roblox-with-swe) is the game Lemon helps build.
- [Hermes](https://hermes-agent.nousresearch.com/docs/) documents the agent framework and supported configuration.
