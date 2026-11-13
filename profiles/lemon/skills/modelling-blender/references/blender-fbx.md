# Headless Blender and FBX

Read this when creating, rendering, exporting or checking a custom mesh. Blender runs in Lemon's SSH workspace; the agent's own tool environment and the SSH sandbox are separate. The sandbox image currently installs Debian Blender, but inspect the actual running version before relying on version-specific behavior.

## Start Blender's Python

`bpy` is available to scripts run **by Blender**. A system `python3` interpreter is not automatically equipped with Blender's module. These commands are run inside the sandbox, with paths in the thread's scratchpad:

```sh
blender --version
blender --background --python-exit-code 1 \
  --python-expr 'import bpy; print(bpy.app.version_string)'
blender --background --threads 4 --python-exit-code 1 --python build_asset.py
blender --background scene.blend --python-exit-code 1 --python check_asset.py
```

`--background` avoids a GUI; `--python-exit-code 1` makes a Python exception fail the command. Use `--help` and the installed Blender's API when a version differs. Build and check the scene locally, but do not render it from these scripts.

Basic `bpy` operations for scripts:

```python
import bpy

bpy.ops.object.select_all(action="SELECT")
bpy.ops.object.delete(use_global=False)  # only in a new, disposable scene
bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, 0))
obj = bpy.context.object
obj.name = "WallPanel"
obj.dimensions = (4, 0.2, 3)
bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)

# Author geometry, UVs, image materials, camera and lights here.
bpy.ops.wm.save_as_mainfile(filepath="/absolute/scratch/asset.blend")
```

Use absolute paths in actual scripts and preserve the editable `.blend`, source script and source maps. Do not delete objects in an existing `.blend` unless the task calls for it; start from an empty scene or modify only selected objects. Do not export a whole scene by accident.

Configure a camera, lights and image size in the scene, then use `rendering-in-modal` for every render, including drafts and round-trip inspection. The lab has no GPU, so its CPU renders are slow and use shared resources. A successful Blender render doesn't establish Roblox material or lighting fidelity.

## Prepare geometry

- Design in Blender's **Z-up** coordinates. Establish intended dimensions in studs with a character or known reference, rather than guessing at final scale. Prefer one coherent module at a time; reuse instances in the game.
- Roblox's general specification limits **each individual mesh** to 20,000 triangles. Check evaluated meshes **after modifiers and triangulation**, not only source polygon counts or the whole model total. Other avatar and accessory budgets can be stricter.
- Check actual exported geometry, transforms, pivot, face normals, smoothing and topology. Roblox's general guidelines call for volume, watertight geometry and quads where possible; avoid unsupported n-gons and zero-thickness surfaces. Test holes and thin/transparent surfaces, since triangulation, culling, and collisions may change them.
- Give each export object one intended material, UVs where an image is needed, and a stable descriptive name. Split incompatible materials or bake them to a UV atlas. Avoid relying on Blender-only procedural shaders, particle hair, simulation, lights, or camera objects as if Roblox imported their appearance or behavior. Make geometry for visible fluff where appropriate; animation and rigged meshes need their own constraints and runtime implementation.
- Apply or intentionally export transforms and modifiers. Blender operators depend on active object, selection and mode; confirm these instead of assuming the prior operation left the right object active. Concave n-gon caps can triangulate incorrectly: inspect the result rather than trusting a successful export.

An evaluated-triangle report for the asset meshes can be placed in the build script:

```python
depsgraph = bpy.context.evaluated_depsgraph_get()
for obj in exported_meshes:  # the exact list you will export
    evaluated = obj.evaluated_get(depsgraph)
    mesh = evaluated.to_mesh()
    try:
        mesh.calc_loop_triangles()
        count = len(mesh.loop_triangles)
        print(obj.name, "triangles:", count, "UV layers:", len(mesh.uv_layers))
        if count > 20_000:
            raise ValueError(f"{obj.name} exceeds the Roblox mesh triangle limit")
    finally:
        evaluated.to_mesh_clear()
```

## Export and check

Use a real list of asset meshes. Select it explicitly, excluding render set pieces, floor, cameras, lights and other helpers. Inspect the screenshot and verify all intended pieces and image nodes before exporting. `FBX_SCALE_UNITS` is the specific enum value; `apply_unit_scale=True` alone did **not** prevent 100× imports in our tests.

```python
bpy.ops.object.select_all(action="DESELECT")
for obj in exported_meshes:
    obj.select_set(True)
bpy.context.view_layer.objects.active = exported_meshes[0]

bpy.ops.export_scene.fbx(
    filepath="/absolute/scratch/asset.fbx",
    use_selection=True,
    object_types={"MESH"},  # for a static asset; rigged exports need armatures too
    path_mode="COPY",
    embed_textures=True,
    apply_scale_options="FBX_SCALE_UNITS",
    axis_forward="Z",
    axis_up="Y",
)
```

Keep Blender's ordinary unit and export scale values at 1 for this approach. The official settings are a starting point; verify scale, axes and pivot in Roblox. Excluding armatures as above is intentional only for static assets. Avoid including animations merely because exporter defaults happen to include them.

Reimport the FBX into a **fresh empty Blender scene** and compare against the intended asset: object list and names, UV layers, each material's image connection, distinct embedded image paths, dimensions, orientations and modifiers. Verify images are packed and visually inspect a render; `packed=True` or a material count alone is not proof that every material references the correct distinct image. Keep this check and its temporary scene separate from the source `.blend` so it doesn't overwrite work. Check file size against the current API limit before upload. The texture reference explains why unique file paths matter.

Roblox's importer may still split, merge, recolor, rescale or omit things after a successful Blender round-trip. Re-check the returned model and the Studio result. See [Roblox Blender guidance](https://create.roblox.com/docs/art/blender), [mesh specifications](https://create.roblox.com/docs/art/modeling/specifications), and [the importer](https://create.roblox.com/docs/studio/importer).
