---
name: texture-search-in-polyhaven
description: Use when searching Poly Haven for CC0 PBR textures.
---

# Search Poly Haven textures

## Search and retrieval

Poly Haven provides high-quality, community-funded PBR materials released under the CC0 (Public Domain) license. Its public REST API requires no authentication and provides direct download URLs for individual texture maps.

Searching and downloading follows two steps: query the assets catalog to find matching material IDs, then fetch the file URLs for that ID at 1k resolution.

| Option | Key / Path | Description |
|---|---|---|
| Asset listing | `/assets?type=textures` | Returns dictionary of all texture assets with categories and names |
| Asset details | `/files/{id}` | Returns download tree for all resolutions and formats |
| Target resolution | `["1k"]` | Recommended resolution for Roblox performance and memory |
| Base color map | `.Diffuse["1k"].jpg.url` | Color / Albedo map for Base Color / ColorMap |
| Normal map (OpenGL) | `.nor_gl["1k"].jpg.url` | Tangent-space normal map formatted for OpenGL (+Y) |
| Roughness map | `.Rough["1k"].jpg.url` | Greyscale roughness map for surface shine |
| Ambient occlusion | `.AO["1k"].jpg.url` | Ambient occlusion map for contact shadows |

## Commands and examples

Execute these commands inside the sandbox terminal to query the API and download texture maps directly into the thread scratchpad.

```sh
# Search Poly Haven for texture assets matching a keyword like 'wood' and extract the top candidates

curl -s "https://api.polyhaven.com/assets?type=textures" | jq 'to_entries | map(select(.value.name | test("wood"; "i"))) | .[0:3] | map({id: .key, name: .value.name, categories: .value.categories})'
```

```json
# Example JSON output of matching assets from Poly Haven

[
  {
    "id": "wood_table_001",
    "name": "Wood Table 001",
    "categories": ["wood", "indoor"]
  },
  {
    "id": "dark_wood",
    "name": "Dark Wood",
    "categories": ["wood"]
  }
]
```

```sh
# Inspect available 1k maps and direct download links for an asset

curl -s "https://api.polyhaven.com/files/wood_table_001" | jq '{diffuse: .Diffuse["1k"].jpg.url, normal_gl: .nor_gl["1k"].jpg.url, roughness: .Rough["1k"].jpg.url}'
```

```json
# Example JSON output containing direct download URLs

{
  "diffuse": "https://dl.polyhaven.org/file/ph-assets/Textures/jpg/1k/wood_table_001/wood_table_001_diff_1k.jpg",
  "normal_gl": "https://dl.polyhaven.org/file/ph-assets/Textures/jpg/1k/wood_table_001/wood_table_001_nor_gl_1k.jpg",
  "roughness": "https://dl.polyhaven.org/file/ph-assets/Textures/jpg/1k/wood_table_001/wood_table_001_rough_1k.jpg"
}
```

```sh
# Download the 1k diffuse, normal and roughness maps into the thread scratchpad

curl -sLo /home/lemon/workspace/scratchpad/textures/wood_table_001_diff.jpg \
  "https://dl.polyhaven.org/file/ph-assets/Textures/jpg/1k/wood_table_001/wood_table_001_diff_1k.jpg"

curl -sLo /home/lemon/workspace/scratchpad/textures/wood_table_001_nor_gl.jpg \
  "https://dl.polyhaven.org/file/ph-assets/Textures/jpg/1k/wood_table_001/wood_table_001_nor_gl_1k.jpg"

curl -sLo /home/lemon/workspace/scratchpad/textures/wood_table_001_rough.jpg \
  "https://dl.polyhaven.org/file/ph-assets/Textures/jpg/1k/wood_table_001/wood_table_001_rough_1k.jpg"
```

## Constraints + Guidelines

- **Select OpenGL normals:** Always select `.nor_gl`, never `.nor_dx`. Roblox strictly requires tangent-space normal maps in the OpenGL (+Y) format.
- **Enforce 1k resolution:** Poly Haven hosts files up to 8k; requesting 4k or 8k textures wastes bandwidth, container disk space, and exhausts Roblox mobile device memory budgets.
- **Polite querying:** Cache the catalog list in the scratchpad if multiple searches are performed in the same session, avoiding redundant multi-megabyte JSON downloads.

## Limitations

- **Client-side filtering:** The Poly Haven `/assets` endpoint does not support server-side text queries; all texture assets are returned in a single JSON dictionary that must be filtered with `jq` or Python.
- **Stylized assets:** Poly Haven focuses almost exclusively on photorealistic real-world scans; it does not offer anime, pixel-art, or hand-painted textures.

## References

- [Poly Haven API documentation](https://api.polyhaven.com/): Official endpoints and OpenAPI specification.
- [Poly Haven LLMs guide](https://polyhaven.com/llms.txt): Agent guidelines and usage instructions.
- [Poly Haven License](https://polyhaven.com/license): Public domain CC0 license terms.
