---
name: rendering
description: Render Blender scenes on a short-lived Modal GPU for visual inspection and presentation. Use for GPU-assisted Blender still renders; use model for Roblox asset creation and integration.
---

# Render Blender scenes with Modal

Use the bundled script for a single Cycles PNG on a Modal T4. Modeling and exporting stay in the SSH workspace; the `.blend` is sent to Modal and the PNG is saved back locally. A Blender render is not proof of appearance in Roblox Studio.

## Prepare

Check the scene has a camera, intended lighting and a compatible Blender version. The `ghcr.io/petri-hub/lemon-render:latest` remote image uses Blender's `bpy` 4.5.0: a file saved by a newer Blender can be incompatible. The image must be published and accessible to Modal before use. Pack eligible textures and linked data and save a separate `.blend`; verify required external resources. Videos, caches and some linked files may need separate transfer, which this single-file script does not provide. Never upload secrets or unrelated files with a scene.

The sandbox image installs the Modal client and requires `MODAL_TOKEN_ID` and `MODAL_TOKEN_SECRET` at startup, passing them to SSH sessions. Credentials are supplied privately by Petri; never print or ask for them in chat. Do not copy someone else's token or assume environment variables cross SSH. If access is unavailable, report the missing setup.

## Render

Run the copy of the script installed in the SSH sandbox (replace the example paths with the thread's scratchpad paths):

```bash
modal run /usr/local/lib/lemon/render.py \
  --input /home/lemon/workspace/scratchpad/scene.blend \
  --output /home/lemon/workspace/scratchpad/preview.png \
  --frame 1 --samples 32 --percentage 50
```

The script never overwrites a result. It uses the scene's active camera and base resolution, sets Cycles CUDA and refuses CPU fallback. It disables automatic script execution on file load. It produces one still, not an animation, bake or an Eevee render; unsupported external caches, addons, scripts or features may change the result. Inspect the result and compare it with the brief; attach it using the workspace's `MEDIA:/absolute/path` convention when requested.

Start with a low-resolution, low-sample preview, then increase only as needed. Render time, GPU queueing, image build and network transfer all affect latency. Check the Modal logs for the selected GPU and errors. If the image builds but no GPU is detected, the scene fails, or an image is missing, report and diagnose rather than claiming success or silently rendering on the homelab.

The function uses one T4, at most one container, no warm pool, one input per container, a two-second idle window and a 600-second execution timeout. Single-use shutdown and the idle window are separate controls; neither is a budget cap, and timeouts do not include queueing. Preemption can restart work. Do not launch long sequences or increase concurrency, GPU size, timeout or retry policy without checking the scope and cost. For animation, discuss frame count and a bounded batch approach first; repeated single-frame cold starts can be inefficient.

## Verify and report

For first use, render a small packed scene containing a camera, light and visibly textured object. Check the PNG, GPU log, elapsed time and Modal usage, and compare with a local low-quality preview. Report the remote Blender version, what was rendered and any missing dependencies. If Modal access or GPU provisioning is unavailable, say the cloud path was not verified.
