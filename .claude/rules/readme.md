---
paths:
  - "README.md"
---

# README

## Purpose

> Keep the repository front page easy to scan, especially its agent roadmaps. This rule governs the root `README.md` layout and roadmap wording; profile documents have their own rules.

## Rules

### ✅ Do

| Rule | Directive |
|---|---|
| **Use the same roadmap shape** | Give every agent `#### Done` followed by `#### Open` — readers can find completed and pending work in the same place for every profile. |
| **Keep bullets short** | Keep each roadmap bullet on one physical line of at most 80 characters, counting `- ` and the status emoji — longer entries wrap and make the roadmap hard to scan. |
| **State one outcome per bullet** | Split distinct outcomes into separate bullets — packed lists hide what is actually done or still pending. |
| **Keep links in References** | Write plain names in roadmap bullets and place relevant links under `## References` — Markdown URLs make bullets long and visually uneven. |
| **Show empty sections plainly** | Write `None listed.` below an empty Done or Open heading — a fake checkbox would imply a task that does not exist. |

### 🚫 Don't

| Rule | Directive |
|---|---|
| **Avoid extra roadmap subsections** | Don't add headings such as “First conversation” or “Roblox collaboration” below an agent — they break the shared Done/Open scan pattern; express the detail in short bullets instead. |

## Reference

The root README keeps its existing top-level sections. Only the `## Roadmap` section uses the agent layout below; `## References` remains the destination for supporting links.

| Level | Shape |
|---|---|
| Agent | `### <emoji> <Name>` |
| Completed work | `#### Done`, then `- ✅ <short outcome>` bullets |
| Pending work | `#### Open`, then `- ⬜ <short outcome>` bullets |
| Empty group | `None listed.` |

## Patterns

### ✅ Correct

```markdown
### 🍋 Lemon

#### Done

- ✅ Connect Lemon's Discord bot with an allowlist.

#### Open

- ⬜ Give Lemon an isolated Roblox development workspace.

## References

- [Roblox game](https://github.com/Petri-Hub/roblox-with-swe): source project
```

### 🚫 Wrong

```markdown
### 🍋 Lemon

#### Roblox collaboration

- ⬜ Set up [roblox-with-swe](https://github.com/Petri-Hub/roblox-with-swe) with every pinned tool, check and release path in Lemon's workspace.
```

> The extra heading hides completion status, and the linked multi-part bullet wraps instead of giving each outcome a short line.
