# Lemon's Modal rendering image

This image contains Python and Blender's `bpy` package for headless Cycles rendering. Modal supplies the GPU drivers at runtime. It does not contain Lemon's workspace, credentials or a running service. `lemon-render` is published separately from `lemon-sandbox` to `ghcr.io/petri-hub/lemon-render`.

```bash
docker build -t lemon-render:dev profiles/lemon/sandbox/rendering
docker run --rm lemon-render:dev python -c 'import bpy; print(bpy.app.version_string)'
```

The image is published on changes to this directory by the dedicated GitHub Actions workflow. The package must be publicly pullable or Modal must be configured with registry credentials before use. A local import verifies dependencies, not T4 availability or a GPU render.
