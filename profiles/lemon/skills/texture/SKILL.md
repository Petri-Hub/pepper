---
name: texture
description: Find, evaluate and choose 2D and 3D textures, PBR materials, and photographic surface maps for Roblox models. Use when someone asks for textures, materials, or surfaces for game objects.
---

# Find and choose textures

## Search strategy

Understand the required material, tiling and visual style before searching. Infer clear requirements from the brief and ask only when a missing decision affects the result.

Route the search to the specialized skill matching the need:

- Use `/texture-search-in-polyhaven` for photorealistic rock, wood, metal, plaster, or ground materials where individual 1K maps (diffuse, normal OpenGL, roughness) can be pulled directly via API.
- Use `/texture-search-in-ambientcg` for tileable architectural surfaces, terrain, ground, or procedural materials bundled in 1K ZIP archives.
- Use Kenney prototype textures for greyboxing, level blockouts, and development grids.
- Use Openverse or Unsplash when a raw photographic reference is requested and full PBR maps are not required.
- Use Blender's internal procedural shader nodes (`bpy`) when an offline, seam-free material with infinite seed variations is preferred.

| Source | Primary use | License | Map format |
|---|---|---|---|
| `Poly Haven` | Photorealistic nature, metals, architectural PBR | CC0 | Direct single-map URLs (JPG/PNG) |
| `ambientCG` | Seamless tileable surfaces, bricks, terrain, fabrics | CC0 | Direct 1K ZIP bundles |
| `Kenney` | Prototype grids, dev textures, stylized game assets | CC0 | Direct PNG files via GitHub |
| `Openverse` | Real-world surface photography (diffuse only) | CC0 / CC-BY | Direct image URLs |
| `Blender BPY` | Procedural generated materials (wood, noise, voronoi) | Built-in | Baked in-container (zero network) |

## Workspace and commands

Use the thread's persistent scratchpad under `/home/lemon/workspace/scratchpad/` to store downloaded maps and metadata. Keep texture files organized per asset to prevent mixing maps across different models.

```sh
# Create a dedicated textures folder in the scratchpad for this task

mkdir -p /home/lemon/workspace/scratchpad/textures
```

```sh
# Check network reachability of texture APIs from the sandbox

curl -Is https://api.polyhaven.com/types | head -n 1
```

```sh
# Download a Kenney prototype grid texture directly for level greyboxing

curl -sLo /home/lemon/workspace/scratchpad/textures/prototype_dark.png \
  https://raw.githubusercontent.com/Calinou/kenney-prototype-textures/master/addons/kenney_prototype_textures/dark/texture_01.png
```

## Presentation

When a material choice is unresolved or the group asks to compare options, hand off candidates to `/texture-answering` to build a visual preview gallery and present the options in Discord with letters, source links, and material traits.

## Constraints + Guidelines

- **License integrity:** Prioritize CC0 (Public Domain) materials. Always record the source URL, creator name, and license terms in the thread scratchpad.
- **Resolution:** Start with 1K maps for ordinary props and choose resolution according to on-screen size, quality, and memory budget. Larger maps may be justified for close-up assets; avoid unnecessary high-resolution downloads.
- **Normal map orientation:** Roblox tangent-space normal maps strictly expect OpenGL (+Y) format. If a source provides DirectX (-Y), invert the green channel in Blender before exporting.
- **Distinct filenames:** Save every map to a distinct file path on disk before loading it into Blender (`diffuse.jpg`, `normal.jpg`, `roughness.jpg`).

## Limitations

- **UV dependence:** A texture image does not apply itself correctly without proper UV unwrapping on the target 3D mesh.
- **Runtime scripting:** Roblox `SurfaceAppearance` instances cannot have their texture map IDs swapped dynamically via runtime client scripts. Preconfigure materials in Studio or through imported model assets.
- **Flat photographs:** A 2D photo from stock sites lacks physical depth and normal data, and often contains baked lighting shadows that look unnatural in 3D game engines.

## References

- [Roblox SurfaceAppearance](https://create.roblox.com/docs/art/modeling/surface-appearance): Specification and expectations for PBR materials in Roblox.
- [Poly Haven](https://polyhaven.com/textures): CC0 public domain 3D texture library.
- [ambientCG](https://ambientcg.com/): Public domain PBR material repository.
- [Kenney Prototype Textures](https://kenney.nl/assets/prototype-textures): Standard grid and greyboxing textures.
- [Openverse](https://openverse.org/): Search index of openly-licensed and CC0 images.
