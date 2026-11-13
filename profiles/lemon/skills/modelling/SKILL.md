---
name: modelling
description: Use when the group asks for a custom 3D model.
---

# Model a custom 3D asset

Start here for any custom mesh, prop or environment module. This skill sets the stages, the review path and the standards every model follows. The hands-on work lives in two skills that you load only at the stage that needs them:

| Load | When |
|---|---|
| `modelling-blender` | You build, texture, render or export the model in Blender. Every custom model needs it. |
| `modelling-roblox` | The group wants the finished model in the game. A model that stays a render, a concept or a local export never loads it. |

A ready-made asset often beats a custom model: when the request leaves room, search the Creator Store with `assets-search` before building one. When the group asks explicitly for custom modelling, honor that request. Textures come from `texture` and renders from `rendering`.

This skill is about a **working asset pipeline**; it does not claim a design is attractive or gameplay-ready.

## 1. Scope and workspace

Work out the asset's use in the game, rough size in studs, style and any reference image from the request. Ask up to three short questions only when shape, style or scope is unclear; otherwise pick defaults and say which. Leave collision, anchoring, texture maps and export details for later stages. When the group asks explicitly for custom modeling, honor that request; do not force a store search or replace the requested work with a store asset.

Use the thread's worktree and a separate, persistent scratchpad under `/home/lemon/workspace/scratchpad/` for scripts, renders, source `.blend`, original texture images and exports. Do not change another thread's work or clear existing game content for a test. Decide which source files and `.rbxm` belong in the project with its existing conventions; keep IDs, creator, source/license and versions recoverable. Avoid putting generated build files, temporary URLs or credentials in Git.

Blender runs directly **inside** Lemon's SSH sandbox; do not assume Lemon can run Docker or Studio there. Check tools and access when a stage needs them, not all up front. The configured Assets MCP supports uploads and asset lifecycle management as well as search and delivery; never assume a test-place key grants asset-write access.

## 2. Work in stages

Each stage ends your turn with a render attached, as the Working rhythm in your instructions describes, unless the person said "direto". If the group redirects, redo that stage only.

| Stage | What to build | What to show |
|---|---|---|
| **Silhouette** | Two or three clearly different blockouts from simple shapes, at the intended scale, with flat grey or single-color materials. No textures, bevels or fine detail. One option is enough when the request includes a sketch or reference with a clear shape. | One low-sample render with the options side by side and labeled A, B, C, or one render per option. Ask which to develop. |
| **Shape** | The chosen option's proportions and main forms. | A render from the same angle, so the change is easy to compare. |
| **Detail and material** | Secondary forms, then UVs and textures through the `texture` skill. | A render of the textured model. |
| **Roblox** | Export, upload and integration, only when the group wants the asset in the game. Load `modelling-roblox`. | The Studio URL and what to check there. |

Keep each stage's script and render in the scratchpad so the next stage starts from the accepted version instead of rebuilding it.

## 3. Choose the review path

| Situation | What to do |
|---|---|
| Routine technical choices or a clear, authorized build | Proceed through the stages without a vote on every mesh or material. |
| Material creative choice is unresolved, or the result visibly misses the brief | Show the options or draft render, explain the tradeoff and ask for the decision before dependent work. |
| The request asks only for a design, render or local export | Stop at that deliverable. Do not upload or change a game. |
| Uploading or updating is within the requested/approved scope | Validate the specific file and creator, then proceed. A request to make an asset usable in a Roblox preview can authorize the uploads needed for that result; don't ask again if the authorization is clear. Avoid unnecessary duplicate uploads. |
| Upload scope, owner, rights, expense or other material consequence is unclear | Explain the concrete asset and owner, and ask the responsible person before the affected upload. An approval for one purpose is not blanket permission to publish to the Creator Store, overwrite another asset, or change a published place. |
| Write credential or permission is missing | Stop that phase and say which permission or owner is needed; do not request a secret in chat, try unrelated keys, or quietly fall back to a less appropriate account. Continue local work. |
| A human is needed to see or play the result | Give the group a ready `serve` preview and focused instructions. A person must confirm the visual and interactive result before calling the feature ready, following `implement` and `test`; don't claim it passed based on a build or thumbnail. |

## 4. Standards for every model

Model at an intended stud scale and keep objects meaningfully named. Keep the source `.blend`, scripts, source images and their provenance in the thread's scratchpad so a later stage starts from the accepted version. Use only material you have the right to use in this project and on Roblox.

## 5. Hand off evidence

Attach renders with the sandbox's `MEDIA:/absolute/path` convention and, once the asset is in the game, give the ready Studio URL through `serve`. Explain what to check in Studio: shape, size beside a character, orientation, texture and lighting, clipping, collision and interaction as relevant. Name what was checked locally, what Roblox reported and what still needs human confirmation. Do not present a Blender render as an in-game screenshot or a headless build as proof of appearance.

Iterate on the same worktree and preview. Follow `implement`, `test` and `deliver` for group feedback, project checks and release; this skill does not override their playtest or delivery gates.
