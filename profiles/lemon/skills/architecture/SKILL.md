---
name: architecture
description: Use when deciding where new feature code lives.
---

# Architecture for game features

You decide how the code is organized. The group decides how the game feels. Read this skill at two moments: **when you plan a feature**, before you write the implementation plan, and **when you implement one**, before you create the first file. Features that are built without it tangle: a weapon that owns the character's speed, a rule that exists once on the server and once on the client, one module that grows to five hundred lines. This skill keeps a stamina bar, a sword and a swimming state able to work together without any of them knowing the others' insides.

Load `architecture-rojo` when you create, move or connect files, and `architecture-netcode` when state or input crosses between server and client. When planning you only need this skill.

## Decide, don't ask

Never hand the group a choice between two implementation shapes. "Should stamina block sprinting or just slow you down?" is a question you answer, because you can judge how it should feel.

- Make the call, say what you chose and why in one sentence, and keep building. The group can veto it; the default is that nobody has to decide.
- Ask only when the answer changes what players see or feel and you cannot judge it: art direction, tone, how hard or scary something is. Ask once, with a recommendation.
- A decision that one line of config can reverse is never worth a question. Put the number in a `Config` module and move on.

## How Roblox code is organized

Roblox is neither object-oriented nor an entity-component system. A game is a tree of instances (parts, folders, scripts) under fixed services, and behavior comes from scripts placed in that tree. Nothing forces a structure, so a quick script dropped into a part works, and that is exactly how tangles start. The structure comes from conventions, which are the rest of this skill. Two engine facts shape everything:

- **Server and client are different programs.** The server owns anything that matters (health, stamina, damage). Each player's client draws, reads input and asks. They talk through `RemoteEvent`s and replicated attributes. `architecture-netcode` covers this.
- **A `ModuleScript` is a file that other scripts `require`.** One module, loaded once, shared by whoever requires it. This is how a feature offers functions to the rest of the game.

## Features, owners and public surfaces

Split the game into **features**: one name, like `player/stamina`, that owns one thing (stamina, combat, water). A feature has a folder in `src/server`, `src/client` and `src/shared` under the same `<family>/<feature>` path, for the parts it needs. Group features into **families** (`player`, `world`, `core`). Then keep four rules:

1. **One owner per piece of state.** Exactly one feature may write it. Everyone else asks through its functions or listens to its signals. If two features write the same value, the last writer wins and players see "sometimes I run in water, sometimes I don't".
2. **A feature shows only its public surface.** What other features may use is the server `init.luau`: a small set of functions and signals. They never reach into another feature's other files.
3. **Features announce facts, not commands.** Stamina fires `OnDepleted` ("this character ran out"). It does not tell sprint to stop. Sprint listens and decides what depletion means for it.
4. **Arithmetic lives in pure functions.** Cost, regeneration and speed math go in a `Resolve.luau` in the feature's shared folder: same inputs, same output, no engine access. Jest can test them without Studio.

The real, working files are in `/home/lemon/.hermes/skills/architecture-rojo/example/`. Stamina's public surface from there, signatures only:

```lua
-- src/server/player/stamina/init.luau
Stamina.OnDepleted = Signal.new() :: Signal.Signal<Model>   -- a fact others can hear

function Stamina.get(character: Model): number?              -- read the value
function Stamina.spend(character: Model, cost: number): boolean   -- all or nothing
function Stamina.drain(character: Model, amount: number): number   -- takes what is there
```

## Patterns that make features compose

Pick the lightest pattern that fits. Each one has working code in the example.

| Situation | Pattern | Example |
|---|---|---|
| A feature has numbers to tune or arithmetic to test | Shared `Config` and `Resolve` | `src/shared/player/stamina/` |
| Other features need to react to something that happened | A signal on the public surface | `Stamina.OnDepleted`, heard by `player/sprint` |
| Many features change one value (walk speed) | Named modifiers on one owner that resolves them | `Movement.setModifier(character, "sprint", 0.5)` |
| A feature must ask others "may I?" without knowing them | A registry of hooks | `Combat.addAttackBlocker`, used by `player/water` |
| The client needs to draw server state | A replicated attribute | The `Stamina` attribute read by the HUD |
| The client asks the server to do something | A `RemoteEvent` carrying intent | `SprintIntent`, `CombatSwing` |
| Per-character setup that must be undone | `Characters.observe` with its cleanup bag | Every server feature in the example |

Use signals first. When a second feature needs the same hook, extract the shared concept instead of adding a special case: sprint and combat both spend stamina, so `Stamina.spend` is that concept. If costs later need to be declared as data per ability (`cost = { resource = "stamina", amount = 10 }`) because several resources appear, move to that form then, not before.

## Before you write code

Write the seams in three lines. Do it in your head for a small change and in the implementation plan for a large one:

```text
Feature: player/combat
Owns:    who may swing and the swing deadline
Exposes: Combat.addAttackBlocker, Combat.OnSwing
Uses:    Stamina.spend, Movement.setModifier
```

Then read the project's `AGENTS.md` yourself (nothing loads it for you in the workspace) and the public surfaces of the features you will touch. A project that predates this layout has no code map in its `AGENTS.md` and no `architecture.toml`: see "Projects that predate this layout" in `architecture-rojo` before you decide where code goes. Decide where the new code goes before opening a file: a new feature gets its own folder, and an existing feature changes only what it owns.

**When you plan**, put these seams in the implementation plan, next to the tasks they shape. The group plan says the same thing in game terms and no filenames, for example: "Stamina is the one place that knows how tired you are. Sprint and attacks both ask it, so a new move like dodging can use it too." Add the seams to the plan before you list the tasks, because they decide the tasks.

## The extensibility test

Before you call a feature finished, name the next feature the group has hinted at and check that it fits by adding files in its own folder. Water that stops attacks is one new feature registering a blocker with combat; combat, movement and stamina stay untouched. If the next feature forces an edit inside an existing one, the boundary is in the wrong place. Fix it now, while the module is small.

## Keep modules small

A module over about 200 lines is doing more than one job. Signs of a tangle: its description needs the word "and", it requires four or more other features, or two different requests would make you edit it. Split it by responsibility before you add the next feature. `make check-architecture` enforces the line limit.

## Changing the structure of an accepted feature

Do not reorganize a feature the group has already accepted unless the next feature needs it, and say why in a sentence the group can follow. When you do:

- Work on its own branch, and run `make check-architecture` and `make build` before anything else.
- Tell the group what to try in Studio, because passing checks do not prove the game runs.
- If the same error comes back after a fix, read its text again before blaming Rojo or the tools. `X is not a valid member of ModuleScript` means the path is wrong. `architecture-rojo` explains the usual cause.

## Failure modes to avoid

- **Asking the group an implementation question.** "Do you want a state layer or events?" Decide, then say what you decided.
- **The god module.** One file that owns stamina, dash, attack lock and speed. Give each owner its own feature.
- **Two owners.** The same rule written on the server and on the client, or two features writing `WalkSpeed`.
- **Reaching into internals.** Requiring another feature's helper file instead of its public surface.
- **Commands between features.** Stamina calling `Sprint.stop()` instead of announcing `OnDepleted`.
- **Architecture theatre.** Building signals, registries and families for a feature with one consumer. Start with the simplest owner and surface, and add a pattern when a second feature needs it.
- **Silencing a check.** Editing `architecture.toml` or deleting a file to make `make check-architecture` pass. Fix the code, or tell Petri why the rule is wrong.
