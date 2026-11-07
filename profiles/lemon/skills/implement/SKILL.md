---
name: implement
description: Implement an agreed feature or fix in a Roblox project. Use when Lemon is asked to change the game, from understanding the request through a rough playable version, the group's feedback rounds and the finished change.
---

# Implement a change

Build in stages and show each one, following the Working rhythm in your instructions. The first thing the group sees should be a rough version running in the Studio preview, not a finished feature.

## 1. Intake and workspace

Restate the player-facing outcome in a sentence. Read the project's instructions and the code the change touches; read more only when you need it.

Resume this thread's existing worktree and branch when one exists. If there is none, create an isolated worktree and branch from the project's current base branch. Never use another thread's worktree or mix unrelated changes in the same branch. Use the `install` skill if the worktree's tools or dependencies are missing, and the `serve` skill so the thread has a ready Studio URL early in the session.

If a new, unrelated request arrives while this feature is active, do not silently discard or merge unfinished work. Keep it isolated and ask Petri how he wants the work prioritized before proceeding.

Ask up to three short questions only when the answer would change what players see, feel or do. Decide routine technical details yourself.

## 2. Look before you build, briefly

Spend a short search on what already exists before writing a significant system or making an asset by hand: the project itself first, then the Creator Store with `assets-search` when a model, sound, decal, font or texture could save work. A Wally package can help for common systems when you can find one quickly. Keep the search inside the budget for the first stop; if nothing clearly fits, build the rough version with placeholders and mention what you could look for.

Inspect a candidate for fit, compatibility with the project's Roblox and Rojo setup, licensing and security before adopting it. Do not import something merely because a search returned it. When the group asks for a custom model, use the `modelling` skill instead of searching the store.

## 3. Rough version

Build the smallest playable version of the idea in the thread's worktree: grey parts, placeholder assets and simple values are fine. Follow the project's existing structure and keep authoritative behavior on the server. Run a quick check that it builds, such as `make build`, then give the group the ready Studio URL and tell them what to try and what is still missing. End the turn there.

## 4. Iterate

Each round of feedback is one stage: the core mechanic first, then content, effects and polish. Change what the group asked for, keep the preview running, say what to try again and stop. When a visual, audio or gameplay choice needs the group, show the options and ask; for routine implementation choices, proceed. Use `assets-answering` to present asset options.

**Never deliver directly to a published place or staging.** During iteration the output is the running preview, not a pull request.

## 5. Finish

When someone in the thread says the feature is finished for now, review the diff and update the project documentation for any behavior or decision that changed. Add or update tests for the behavior the change needs to verify, and run the full checks with the `test` skill. Report what passed, what failed and what still needs a Studio playtest.

Stop the thread's preview and hand off to the `deliver` skill. Do not open a pull request, merge or publish before this point unless the group explicitly asks to end the iteration early.

After merge, do not wait for the publishing workflow before starting the next task. CI handles publication; Petri monitors it. Remove the thread's worktree once the correct PR is merged, after checking for any uncommitted, untracked or unpushed work.

## Failure modes to avoid

- **Bazooka delivery.** Going from request to merged PR without a preview and the group's word that it is finished.
- **Silent marathon.** Building the whole feature, its tests and its polish before the group has seen anything. Show the rough version first.
- **Endless search.** Searching the store and package registry for many tool calls before building anything. A placeholder is fine for a first version.
- **Wrong category assumption.** Reaching for a 3D model when the task actually needs a sound, a decal, a font or a package. Think about the full scope of the feature first.
- **Waiting for CI before moving on.** Once a PR is merged and CI is running, that's automation, not Lemon's job to monitor. Start the next task.
- **Blending threads.** Each thread owns its worktree. Never write in another thread's worktree or silently continue one thread's work inside another.
