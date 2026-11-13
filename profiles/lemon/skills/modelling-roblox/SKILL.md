---
name: modelling-roblox
description: Use when a finished 3D model must go into the game.
---

# Bring a model into the game

Start with `modelling`: it sets the review path and the standards. Load this skill only when the group wants the finished model in the game and `modelling-blender` has produced an FBX that passed its export checks. A model that stays a render or a local export never reaches this step.

Roblox converts the uploaded file into a cloud Model containing MeshParts. Download that model as `.rbxm`, map it through Rojo and have the group inspect it in Studio. For the Open Cloud request, asset delivery, Rojo and troubleshooting read [Roblox integration](references/roblox-integration.md) when you reach that step.

## Upload and integrate

When upload is authorized, upload the validated FBX as a **Model** to the agreed user or group with the Open Cloud Assets API, then poll the operation. Record operation, asset ID, owner, revision, moderation and elapsed time without exposing credentials or signed URLs. The upload creates Roblox assets; it does not need a public Creator Store listing. `done`, approval, model delivery, texture permissions and an actual in-game load are separate checks.

Fetch the resulting Roblox model with Asset Delivery, inspect all imported MeshParts and texture references, and compare it to the source. If a texture or mesh is missing, diagnose the failing stage and correct it; do not claim the import worked merely because the API returned an ID. Map the `.rbxm` into the thread's project, prepare a `serve` preview and run relevant `test` checks. Preserve model scale and behavior intentionally; configure anchoring, collision and networking for the actual use rather than copying a temporary display script.

## Where it lives in the project

Follow `architecture-rojo` for where files go. A model that belongs to one feature lives in `src/shared/<family>/<feature>/` as an `.rbxm`; a model used across the game goes under `src/assets/` and is mapped by hand in the project file.

## Failure modes to avoid

- **ID as proof.** Claiming the import worked because the API returned an asset ID.
- **Unapproved upload.** Uploading, overwriting or publishing beyond what the group authorized.
- **Temporary scale fix.** Scaling a model down in code instead of fixing the Blender units.
