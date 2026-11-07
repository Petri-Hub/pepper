---
name: rendering
description: Plan and review Blender renders for visual previews or presentation. Use when a 3D scene or asset needs a rendered image; use model for asset creation and Roblox integration.
---

# Render a 3D scene

## Render strategy

Determine the purpose, subject, camera angle, lighting, background, resolution and required output before rendering. Inspect the scene and project instructions. For an ordinary Blender still, use `/rendering-in-modal` to render on the T4 instead of loading the homelab. Use `model` to create or export an asset and integrate it into Roblox.

Start with a low-resolution, low-sample preview and inspect it for framing, shape, color, lighting, seams and missing objects or textures. Adjust the scene as needed before producing a higher-quality image. When a creative decision is unresolved, show the group the preview and ask for the decision; a technically successful render is not design approval.

## Workspace and presentation

Keep the source scene, required assets and renders in the thread's persistent scratchpad under `/home/lemon/workspace/scratchpad/`, organized by task. Preserve the source file and avoid overwriting a previous result. When sharing a preview, use `MEDIA:/absolute/path` and explain what it shows and what still needs review.

## Constraints + Guidelines

- **Dependencies:** Check the active camera, lighting and material resources before submitting a job. Pack eligible assets into a copy of the scene and verify any resources that cannot be packed.
- **Cost and iteration:** Choose settings appropriate to the requested output. Start small, inspect the result and increase quality only when useful. Consider the effect of resolution, samples and render duration on cost.
- **Data:** Send only files needed for the render to the selected service. Keep credentials and unrelated files out of the scene and output.
- **Fallbacks:** If the chosen renderer is unavailable or unsupported, explain the limitation and choose a suitable path with the group; do not silently put a heavy render on the homelab.

## Limitations

- **Roblox appearance:** Blender materials and lighting do not necessarily match Roblox. A render is a design preview, not evidence that an asset looks or works correctly in Studio.
- **FBX export:** Rendering and export are separate operations. Export and validate FBX locally through `model`; a successful render does not establish export or upload correctness.
- **Animation and other engines:** Select a workflow that supports the requested output. The current Modal helper renders a single Cycles still; it does not render an animation, bake textures or produce an Eevee render.

## References

- [`rendering-in-modal`](../rendering-in-modal/SKILL.md): Prepare and render a packed scene on Modal.
- [`model`](../model/SKILL.md): Build, export and integrate Roblox assets.
- [Blender rendering documentation](https://docs.blender.org/manual/en/latest/render/): Cameras, render engines and output.
