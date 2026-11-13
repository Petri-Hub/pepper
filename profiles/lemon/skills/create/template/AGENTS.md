# Agent guide

How this game's code is organized, and where a new feature goes. Read this before you plan or build anything. `make check-architecture` enforces the rules below; the rules live in `architecture.toml`.

## Layout

A **feature** is one `<family>/<feature>` path (like `player/stamina`) that owns one thing (stamina, combat, water). Features are grouped into **families** (`player`, `world`, `core`). A feature has up to three parts, one in each of the three source folders, under the same `<family>/<feature>` path:

```text
src/
├── server/
│   ├── init.server.luau        starts every server feature; never edited
│   └── <family>/<feature>/     owns the truth; init.luau is the feature's public surface
├── client/
│   ├── init.client.luau        starts every client feature; never edited
│   └── <family>/<feature>/     draws and reads input; init.luau is the feature's entry point
└── shared/
    └── <family>/<feature>/     config and pure functions; loaded by both sides, no engine access, no state
```

Rojo maps `src/server`, `src/client` and `src/shared` to `ServerScriptService.Server`, `StarterPlayerScripts.Client` and `ReplicatedStorage.Shared`. Adding a feature means adding folders; nothing else changes.

## Rules

- **One owner per piece of state.** Only the owning feature writes it. Others call its public functions or listen to its signals.
- **Cross-feature requires go through `init.luau`** (the public surface) or the other feature's `shared/` files. Never into another feature's internals.
- **The client never requires the server, and the server never requires the client.** They talk through attributes (state) and RemoteEvents (intent).
- **Features do not depend on each other in a loop.** Extract what they share into a third feature.
- **Modules stay under 200 lines.** Split by responsibility.
- **`require` takes a plain instance path**, so it can be checked.

## Features

Keep this table current when a feature is added, or when what it owns, exposes or listens to changes.

| Feature | Owns | Exposes (server `init.luau`) | Listens to |
|---|---|---|---|
| `core/characters` | The list of live characters and their cleanup | `observe(callback)` | Player and character events |
