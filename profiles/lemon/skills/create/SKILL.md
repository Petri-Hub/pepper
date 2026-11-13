---
name: create
description: Use when the group wants to start a new game.
---

# Create a new game

Start a new game from the bare template in this skill: a Rojo project with a baseplate, a server and a client script that start every feature, one infrastructure feature (`core/characters`) and one Jest test. Games are built as features under `src/server`, `src/client` and `src/shared`, as the `architecture` skills describe. The game lives only in your workspace as a local Git repository. It has no GitHub repository, CI or publishing until Petri creates them.

## 1. Name the game

Ask for the game's name if the request doesn't give one. Derive its folder name: lowercase letters, digits and hyphens, 3 to 40 characters, for example `cidade-neon` for "Cidade Neon". Say the folder name you chose.

Check that `/home/lemon/workspace/projects/<name>` doesn't exist yet. If it does, stop and ask for another name; never overwrite or reuse an existing project.

## 2. Copy the template

Hermes copies this skill into your sandbox, so the template is at `/home/lemon/.hermes/skills/create/template`. Copy it, dotfiles included, and fill in the name:

```sh
# Copy the template into a new project folder.
name=cidade-neon
dest=/home/lemon/workspace/projects/$name
mkdir "$dest"
cp -a /home/lemon/.hermes/skills/create/template/. "$dest/"
cd "$dest"

# Replace the placeholder name in the project files.
sed -i "s/__GAME__/$name/g" default.project.json test.project.json wally.toml
chmod +x scripts/*.sh
```

If the template folder is missing, tell Petri the skill files didn't reach your sandbox; do not rebuild the template from memory.

## 3. Install and check

From the new project's root:

```sh
# Install the pinned tools and the test packages, which creates wally.lock.
rokit install --no-trust-check
wally install

# Check that the empty game formats, lints, builds and keeps its architecture.
make format-check
make lint
make check-architecture
make build
```

Run the Jest test on Open Cloud with `make test-on-ocale` once, so the group knows the test flow works. It uses the shared test place configured in your sandbox; see the `test` skill. If a step fails, report the error; don't leave a half-made project behind without saying so.

## 4. Make it a Git repository

```sh
# Create the repository on a main branch with a first commit.
git init -b main
git config user.name "lemon-podcast-3-0-s-bot[bot]"
git config user.email "351156657+lemon-podcast-3-0-s-bot[bot]@users.noreply.github.com"
git add -A
git commit -m "chore: scaffold the game from Lemon's template"
```

Check `git status` afterwards: `DevPackages`, `dist` and `.jest-roblox` stay ignored, and `wally.lock` is committed. Do not add a remote. The project's base branch is `main`.

## 5. Hand off

Tell the thread the game's name and folder, what it contains and which checks passed. Offer the next step: a Studio preview with `serve` so people can see the empty place, or start building with `implement`. Work in thread worktrees under `/home/lemon/workspace/sessions/<name>/` as with any other project.

## What the template has

| Path | Purpose |
|---|---|
| `default.project.json` | The game's Rojo project: the baseplate, lighting and sound settings, the `Packages` folder and the mapping of `src/server`, `src/client` and `src/shared`. |
| `src/server/init.server.luau`, `src/client/init.client.luau` | Start every feature found under their own folder. You never edit them to add a feature. |
| `src/server/core/characters/`, `src/shared/core/characters/` | The one feature the template ships: `Characters.observe` runs a feature's setup for each character and cleans it up. |
| `architecture.toml`, `scripts/architecture/` | The architecture rules and the checker behind `make check-architecture` and `make test-architecture`. |
| `AGENTS.md` | The game's code map for agents: layout, rules and a table of features. Keep it current. `docs/` stays free for the game's own documentation. |
| `test.project.json`, `jest.config.toml`, `tests/specs/` | The test place and the Jest specs. |
| `rokit.toml`, `wally.toml` | Pinned tools (Rojo, StyLua, Selene, Wally, jest-roblox-cli, rojo-share), the `sleitnick/signal` package and the test packages. |
| `Makefile` | `build`, `serve`, `format-check`, `format-apply`, `lint`, `check-architecture`, `test-architecture`, `test-on-ocale` and `test-on-system`. |
| `.stylua.toml`, `selene.toml`, `.pre-commit-config.yaml` | Formatting and linting rules. |
| `scripts/` | Run the Jest tests in Studio on Linux through Vinegar, for people developing on their own computer. |
| `.env.example` | The variables for running tests on Open Cloud from a computer without your sandbox's settings. |

There is no README, license, CI or publishing workflow on purpose. Petri adds them when the game gets a GitHub repository.

## Failure modes to avoid

- **Overwriting a project.** Reusing a name that already exists in `projects/`.
- **Inventing the template.** Writing project files from memory when the template folder is missing.
- **Adding a remote or CI.** Creating a GitHub repository, a remote or workflows; that is Petri's step.
- **Building the game in the scaffold.** `create` makes the empty project. Gameplay starts afterwards in a thread worktree with `implement`.
- **Copying the architecture example into a new game.** The `architecture-rojo` example is a reference. A new game starts with `core/characters` only, and features are added when the game needs them.
