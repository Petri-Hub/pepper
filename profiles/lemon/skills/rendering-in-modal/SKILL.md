---
name: rendering-in-modal
description: Render a packed Blender scene as a single Cycles PNG on a short-lived Modal T4. Use when the rendering workflow needs an off-host GPU still render.
---

# Render Blender scenes with Modal

## Rendering workflow

The sandbox sends a `.blend` to a Modal function and saves the resulting PNG locally. The function uses the active scene's camera and base resolution, Cycles CUDA and the frame, sample count and resolution percentage supplied to the command.

Check the scene has a camera, intended lighting and a compatible Blender version. The `ghcr.io/petri-hub/lemon-render:latest` image uses Blender's `bpy` 4.5.0: a file saved by a newer Blender can be incompatible. The image must be published and accessible to Modal. Pack eligible textures and linked data and save a separate `.blend`; verify required external resources.

The sandbox installs the Modal client and requires `MODAL_TOKEN_ID` and `MODAL_TOKEN_SECRET` at startup, passing them to SSH sessions. Credentials are supplied privately by Petri; never print or ask for them in chat. If access is unavailable, report the missing setup.

## Commands and examples

Run the script installed in the SSH sandbox, using the thread's scratchpad paths:

```bash
modal run /usr/local/lib/lemon/render.py \
  --input /home/lemon/workspace/scratchpad/scene.blend \
  --output /home/lemon/workspace/scratchpad/preview.png \
  --frame 1 --samples 32 --percentage 50
```

The script refuses to overwrite an existing result or fall back to CPU. It disables automatic script execution on file load. Check the Modal logs for the selected GPU and errors, then inspect the PNG. For a first-use check, render a small packed scene with a camera, light and visibly textured object; report the result and any missing dependencies.

## Constraints + Guidelines

- **Lifecycle:** The function requests one T4, at most one container, no warm pool, one input per container, a two-second idle window and a 600-second execution timeout. Single-use shutdown and the idle window are separate controls; neither is a budget cap, and timeouts do not include queueing. Preemption can restart work.
- **Cost:** Start with a low-resolution, low-sample preview. Check the scope and cost before increasing concurrency, GPU size, timeout or retry policy, or launching long sequences.
- **Diagnostics:** Render time, GPU queueing, image builds and transfer all affect latency. If the GPU is missing, the scene fails or a texture is absent, report and diagnose the failure rather than claiming success or silently rendering on the homelab.
- **Data:** Do not upload secrets or unrelated files with a scene. Return the PNG to the thread's scratchpad and use `rendering` for inspection and presentation.

## Limitations

- **One still:** The helper renders one Cycles PNG; it does not render animations, bake textures or run Eevee. For animation, discuss frame count and a bounded batch approach; repeated single-frame cold starts can be inefficient.
- **External resources:** Videos, caches and some linked files cannot be packed into the `.blend` and need separate transfer, which this helper does not provide. Missing resources can produce an incorrect image.
- **Scripts and add-ons:** Automatic scripts are disabled, and remote add-ons may differ from the local Blender installation. Scenes depending on them may render differently or fail.
- **Image compatibility:** Blender versions and GPU availability can affect scene compatibility and rendering. A successful local preview does not guarantee a compatible remote scene.

## References

- [`rendering`](../rendering/SKILL.md): Choose, inspect and present renders.
- [Modal Blender example](https://modal.com/docs/examples/blender_video): Blender and GPU rendering on Modal.
- [Blender packed data](https://docs.blender.org/manual/en/latest/files/blend/packed_data.html): Packing external resources into a scene.
