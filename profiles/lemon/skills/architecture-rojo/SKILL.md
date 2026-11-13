---
name: architecture-rojo
description: Use when adding files or modules to a Rojo project.
---

# Where code goes in a Rojo project

Start with `architecture`: it explains owners, public surfaces and the patterns. This skill is the file-level layer: where each file lives, how a `require` finds it, and the commands that keep the project honest. The game template from `create` already follows it.

## The layout

```text
src/
├── server/
│   ├── init.server.luau            starts every server feature; you never edit it
│   └── <family>/<feature>/         init.luau is the public surface; other files are private helpers
├── client/
│   ├── init.client.luau            starts every client feature; you never edit it
│   └── <family>/<feature>/         init.luau is the entry point; reads input, draws
└── shared/
    └── <family>/<feature>/         config and pure functions: loaded by both sides, no engine access, no state
```

A feature is one `<family>/<feature>` path, repeated in each of the three folders it needs (`player/stamina` has a server part, a client part and a shared part). It needs only the folders it uses. Every server and client feature folder needs an `init.luau`: that file is the feature, and the bootstrap scripts require it automatically, so a new feature starts without any wiring.

Rojo maps the three source folders directly, so adding a feature means adding folders and nothing else. No project file changes. They land here:

| Folder | Instance in Studio |
|---|---|
| `src/server` | `ServerScriptService.Server`, a `Script` whose children are the families |
| `src/client` | `StarterPlayer.StarterPlayerScripts.Client`, a `LocalScript` whose children are the families |
| `src/shared` | `ReplicatedStorage.Shared` |

So `player/stamina` is `ServerScriptService.Server.player.stamina`, `StarterPlayer.StarterPlayerScripts.Client.player.stamina` and `ReplicatedStorage.Shared.player.stamina`.

## Paths: what `script` means

A bad `require` path is the commonest way to break a game that builds fine. `script` is the module itself, and where its neighbours sit depends on how the file is named:

```lua
-- server/player/stamina/Main.luau is a plain module. Its neighbours are siblings:
local Helper = require(script.Parent.Helper)

-- server/player/stamina/init.luau IS the folder. Its neighbours are its children:
local Helper = require(script.Helper)

-- Reaching another feature starts from a service, never from script:
local Stamina = require(ServerScriptService.Server.player.stamina)
```

`script.Parent.Helper` inside an `init.luau` fails in Studio with `Helper is not a valid member of ...`, even though `make build` passes. `make check-architecture` resolves every `require` against the tree Rojo builds and reports the failing step. Write each `require` as a plain instance path from `script` or from `game:GetService(...)` (a local alias of those is fine), so it can be checked.

## Projects that predate this layout

Games made before the feature layout keep flat modules directly in `src/server`, `src/client` and `src/shared` (for example `src/server/CharacterState.luau`), with no `<family>/<feature>` folders, no `architecture.toml` and no `make check-architecture`. For these:

- **Do not restructure them unasked.** The group accepted that code. Apply the ideas from `architecture` inside the existing structure: one owner per piece of state, other code reaching it through functions and signals, new behavior in its own module.
- **Say it when the structure blocks you.** When the next feature cannot fit without editing a module that owns something else, or a module has passed 200 lines, tell the group in one sentence and propose moving to the feature layout as its own task.
- **Migrate on its own branch, one feature at a time,** and never in the middle of a feature request. Copy `architecture.toml`, `scripts/architecture/`, the Makefile targets, the layout and rules sections of `AGENTS.md` (merged into the game's own `AGENTS.md` if it has one) and the bootstrap scripts from the `create` template, make the project file map `src/server`, `src/client` and `src/shared` as the template's does, move one feature into `<family>/<feature>` folders, then run `make check-architecture` and `make build`. Ask the group to try the preview before the next feature, because a clean check does not prove the game still runs.
- **Revert instead of pushing through.** If Studio breaks and a second fix does not clear it, return to the last working commit, keep the attempt on a branch and say what failed.

## Adding a feature

1. Seams first, as `architecture` describes: what it owns, exposes and uses.
2. Create the folders and files under `src/server/<family>/<feature>/`, `src/client/<family>/<feature>/` and `src/shared/<family>/<feature>/`, only for the parts it needs. Copy the shape of the nearest feature in the example, not the whole example.
3. `make check-architecture`, then `make build`.
4. Add specs for any shared `Resolve.luau` under `tests/specs/` (see the example specs) and add the feature to the table in `AGENTS.md`.
5. If the preview is running and Studio does not show the new folders, check that `rojo serve` is still alive with the `serve` skill, and restart it if not. In one session a large move of files left the Rojo preview half-synced, with some new modules present and their folders missing. Ask the group to disconnect and reconnect the Rojo plugin.

## Per-character setup

Anything that holds state per character needs cleanup, or it leaks after the character dies. `Characters.observe` runs your setup for every character now and in the future, and hands you a bag that is emptied when the character goes away:

```lua
local Characters = require(ServerScriptService.Server.core.characters)

Characters.observe(function(character, player, cleanup)
	records[character] = { value = Config.Max }
	local connection = character:GetAttributeChangedSignal("Armed"):Connect(onArmed)

	cleanup.add(function()
		records[character] = nil
		connection:Disconnect()
	end)
end)
```

## Signals

Wally installs `sleitnick/signal` as `ReplicatedStorage.Packages.Signal`; the version is pinned in `wally.toml`. It is typed, so annotate what a signal carries:

```lua
local Signal = require(ReplicatedStorage.Packages.Signal)

Stamina.OnDepleted = Signal.new() :: Signal.Signal<Model>

-- listener, in another feature
Stamina.OnDepleted:Connect(function(character)
	stop(character)
end)
```

- A signal announces a fact in the past tense. A listener decides its own reaction.
- A listener must not fire back into the signal that woke it, and must not yield: use `task.spawn` for slow work.
- Listeners created per character go in the character's cleanup bag. Module-level listeners need no cleanup.

To add another package, add it to `wally.toml`, run `wally install`, and require it from `ReplicatedStorage.Packages`. Check the package is maintained and fits Roblox first; do not add one because a search returned it.

## Models and assets

A model that belongs to one feature lives in `src/shared/<family>/<feature>/` as an `.rbxm`; the checker ignores files that are not Luau. A model shared across the game goes under `src/assets/` and is mapped by hand in the project file.

## The checks

```sh
make check-architecture   # run every rule below
make test-architecture    # the checker's own tests, only when you change the checker
```

The rules live in `architecture.toml`. Hard-coded rules: a `require` must resolve and be written statically, every source file sits under `src/server`, `src/client` or `src/shared` (so Rojo loads it), files sit at `<family>/<feature>/` and not loose in a realm or family folder, server and client features have an `init.luau`, `shared/` stays pure, features do not depend on each other in a loop, and no module exceeds the line limit. Import rules are declarative `[[forbid]]` entries:

```toml
[[forbid]]
name = "client-never-requires-server"
from = ["src/client/**"]
to = ["src/server/**"]
reason = "The client cannot load server code. Send intent through a RemoteEvent."
```

Each violation prints `path:line: [rule] message`. Fix the code. Do not loosen a rule or delete a file to get a green check; if a rule is wrong for the game, tell Petri which one and why.

## The worked example

`/home/lemon/.hermes/skills/architecture-rojo/example/` holds five working features and two Jest specs, laid out as they would sit in a game. Read them before writing your first feature, and copy only what the game needs.

| Feature | Shows |
|---|---|
| `player/stamina` | An owner: config, pure resolver, server surface with a signal, a client HUD |
| `player/movement` | Many writers, one resolved value: named speed modifiers |
| `player/sprint` | A consumer of two other features, an intent remote, client prediction and correction |
| `player/combat` | A hook registry (`addAttackBlocker`) so other features can say "not now" |
| `player/water` | A feature added later by creating files only in its own folder |

The example expects the template's `core/characters` and `Packages.Signal`, which `create` provides. It was built and checked together with the template: formatting, lint, `rojo build` and `make check-architecture` pass. The specs have not been run in Roblox.

## Failure modes to avoid

- **Loose files.** A file directly in `src/server`, in a family folder, or outside the three source folders. Put it in a `<family>/<feature>/` folder; Rojo never loads files outside the source folders.
- **`script.Parent` in an `init.luau`.** See Paths above.
- **Requiring through a variable you build.** `require(features[name])` hides the dependency from the checker and from the reader.
- **Copying the whole example.** A horror game does not need sprint; take the pattern, not the feature.
- **Editing the bootstrap scripts to start a feature.** `init.server.luau` and `init.client.luau` start every feature that has an `init.luau`. A feature that does not start is missing that file.
