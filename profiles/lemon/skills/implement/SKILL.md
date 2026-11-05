---
name: implement
description: Implement an agreed feature or fix in a Roblox project. Use when Lemon is asked to change the game, from understanding the request through preparing a local preview for the group to test.
---

# Implement a change

## 1. Intake and workspace

Restate the player-facing outcome and any important acceptance criteria briefly. Read the project's instructions, relevant documentation, existing code, and current assets before touching anything.

Resume this thread's existing worktree and branch when one exists. If there is none, create an isolated worktree and branch from the project's current base branch. Never use another thread's worktree or mix unrelated changes in the same branch.

If a new, unrelated request arrives while this feature is active, do not silently discard or merge unfinished work. Keep it isolated and ask Petri how he wants the work prioritized before proceeding.

Clarify the intended player experience and the boundaries of the change before building. Ask the group only when an ambiguity would meaningfully change the result; make routine technical decisions yourself.

## 2. Look before you build

Before writing a significant piece of code or making a creative asset by hand, search what already exists. This applies across every category a task may touch — not every task needs a 3D model, but many tasks benefit from an existing sound, font, decal, MeshPart, texture, animation, or Wally package.

**What to check, in order:**

1. **The project itself.** Existing scripts, modules, models and assets in the worktree may already cover or partially cover the request.
2. **Wally packages.** The package registry holds many reusable mechanics, utilities and systems — gun systems, camera controllers, run mechanics, inventory frameworks. Search it before writing common patterns from scratch.
3. **Creator Store.** Use the `assets-search` skill to find models, MeshParts, decals, textures, sounds, fonts, videos and plugins. Use the established visual style and project docs to guide what to look for and what to filter out.

**Evaluate before adopting.** Inspect candidates for fit, quality, compatibility with the project's Roblox/Rojo setup, maintenance, licensing and potential security risks. Do not import something merely because a search returned it.

**Custom assets have a high bar.** Modeling or rigging by hand is slow, hard to inspect in this environment, and usually produces a worse result than a suitable existing asset. If no suitable asset exists after a genuine search, explain why and what would be needed; a modeling workflow is a separate, future topic. Do not improvise a custom model mid-implementation without flagging it.

## 3. Build

Set up the worktree with the `install` skill if its tools or dependencies are missing. Use the `serve` skill to prepare the thread's local preview at the start of a development session.

Make focused, incremental changes in the thread's worktree. Follow the project's existing structure and keep authoritative behavior on the server. When a visual, audio or gameplay choice needs the group's input, share the options and ask; for routine implementation choices, proceed.

When importing an asset chosen by the group, inspect its contents and suitability before adding it. Use the `assets-answering` skill to present options; use the `assets-search` skill to evaluate and retrieve them.

Add or update tests for behavior the change needs to verify, following the `test` skill.

## 4. Preview and iterate

**Never deliver directly to a published place or staging.** The output of an implementation session is a local preview via Rojo Share, not a merged PR.

Once enough of the feature is working to be useful to try, give the group the ready Studio URL and invite them to connect and playtest. Tell them what to look for and what still needs work. Keep the preview running between messages.

Iterate with the group based on their feedback. Each round of feedback is cheap here; the preview is already running. Continue until the group says the feature is ready, or until a new, unrelated request is accepted.

## 5. Finish

When the group confirms the feature is ready, review the diff and update relevant project documentation for any behavior or decision that changed.

Run the checks appropriate to the change using the `test` skill. Report what passed, what failed and what still needs a Studio playtest.

Stop the thread's preview and hand off to the `deliver` skill when the work is ready for a pull request. Do not open a PR, merge or publish before this point unless the group explicitly asks to end the iteration early.

After merge, do not wait for the publishing workflow before starting the next task. CI handles publication; Petri monitors it. Remove the thread's worktree once the correct PR is merged, after checking for any uncommitted, untracked or unpushed work.

## Failure modes to avoid

- **Bazooka delivery.** Going from request to merged PR without a local preview and the group's confirmation. The group must be able to see and test before anything ships.
- **Hand-building without searching.** Writing code or making assets from scratch before checking the project, Wally, and the Creator Store. This wastes time and often produces a worse result. (Real example: modeling an AK-47 by hand and writing a Painter's Algorithm from scratch when a better asset already existed.)
- **Wrong category assumption.** Reaching for a 3D model when the task actually needs a sound, a decal, a font, or a Wally package. Think about the full scope of the feature first.
- **Waiting for CI before moving on.** Once a PR is merged and CI is running, that's automation — not Lemon's job to monitor. Start the next task.
- **Blending threads.** Each thread owns its worktree. Never write in another thread's worktree or silently continue one thread's work inside another.
