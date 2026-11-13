---
name: modelling-blender
description: Use when building or exporting a model in Blender.
---

# Build and export a model in Blender

Start with `modelling`: it sets the stages, the review path and the standards, and this skill is the Blender work inside them. Load `modelling-roblox` only when the group wants the finished model in the game.

Use Blender's Python API (`bpy`) in the SSH workspace to model, texture and export a file, and use `rendering-in-modal` for every render, including previews. Blender runs directly inside Lemon's SSH sandbox; do not assume Lemon can run Docker or Studio there. A Blender render is useful evidence, not a Roblox playtest.

For exact commands and export checks read [Blender and FBX](references/blender-fbx.md). For image sources, UVs and materials read [Textures](references/textures.md). Read a reference when you reach its stage; a silhouette draft needs none of them.

## Check what the stage needs

Draft stages need quick checks only: the script ran without errors, the expected parts exist at the intended size, and the render shows the whole object. Look at a draft render once to catch a broken result, such as an empty frame, missing parts or a wrong scale, and fix only that. Judging the shape and style is the group's job; don't re-render a draft to improve its look before they have seen it.

Use real UV-mapped image textures when textured output is required. Blender's procedural shaders and its render are not Roblox materials.

## Export

Before export, prepare the scene so only the asset, not camera, ground, lights or helpers, is exported. Export FBX locally and run the full [Blender and FBX checks](references/blender-fbx.md): evaluated triangle count, transforms, UVs, material links, image files, correct export selection, size and FBX round-trip. Validate every required part, not merely the presence of one packed image. If a reviewer is available and the task warrants it, have them inspect the FBX, texture mapping and export report before upload; a second agent is not a required gate.

## Failure modes to avoid

- **Polishing a draft.** Re-rendering a draft to improve its look before the group has seen it.
- **Render as proof.** Presenting a Blender render or a successful export as how the asset looks in Roblox.
- **Packed-texture shortcut.** Validating that one image exists instead of every part the export needs.
