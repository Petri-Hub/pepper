---
name: texture-search-in-ambientcg
description: Search, inspect and download CC0 seamless PBR material packs from ambientCG's REST API. Use when looking for tileable architectural surfaces, terrain, ground, plaster, stone or sci-fi materials.
---

# Search ambientCG textures

## Search and retrieval

ambientCG hosts over 2,000 seamless, tileable PBR materials created by Lennart Demes and released under the CC0 (Public Domain) license. Its REST API supports server-side keyword search, category filtering, and popularity sorting.

Unlike Poly Haven which provides individual image URLs, ambientCG packages each resolution into a standard ZIP archive. Downloading requires fetching the 1K-JPG bundle using its deterministic download URL pattern, followed by extracting the specific maps needed for Roblox.

| Parameter | Default | Allowed values | Purpose |
|---|---|---|---|
| `q` | — | Keywords (e.g. `brick`, `stone`, `wood`, `metal`) | Search query matching asset titles and tags |
| `type` | `Material` | `Material`, `Decal`, `Atlas`, `Terrain` | Filter asset category |
| `sort` | `Popular` | `Popular`, `Latest`, `Downloads`, `Alphabet` | Sorting order for results |
| `limit` | `100` | Integer between `1` and `250` | Maximum number of results to return |
| `file` | — | `{AssetID}_1K-JPG.zip`, `{AssetID}_1K-PNG.zip` | Target file format and resolution for download |

## Commands and examples

Execute these commands inside the sandbox terminal to find materials, download bundles, and extract the required texture maps into the scratchpad.

```sh
# Search ambientCG for popular brick materials and list asset IDs, tags, and preview thumbnails

curl -s "https://ambientcg.com/api/v2/full_json?type=Material&q=brick&sort=Popular&limit=3" \
  | jq '.foundAssets[] | {id: .assetId, tags: .tags[0:4], preview: .previewImage["256-PNG"]}'
```

```json
# Example JSON output of found materials from ambientCG

{
  "id": "Bricks076",
  "tags": ["brick", "wall", "red", "old"],
  "preview": "https://acg-media.struffelproductions.com/file/ambientCG-Web/media/thumbnail/256-PNG/Bricks076.png"
}
```

```sh
# Download the 1K-JPG material ZIP bundle into the thread scratchpad (using -L to follow redirects)

curl -sL -o /home/lemon/workspace/scratchpad/textures/Bricks076_1K-JPG.zip \
  "https://ambientcg.com/get?file=Bricks076_1K-JPG.zip"
```

```sh
# Extract only the Color, NormalGL, and Roughness maps from the ZIP archive

unzip -jo /home/lemon/workspace/scratchpad/textures/Bricks076_1K-JPG.zip \
  "*_Color.jpg" "*_NormalGL.jpg" "*_Roughness.jpg" \
  -d /home/lemon/workspace/scratchpad/textures/Bricks076/
```

```sh
# Verify the extracted map files and clean up the archive to preserve disk space

ls -lh /home/lemon/workspace/scratchpad/textures/Bricks076/ && \
  rm -f /home/lemon/workspace/scratchpad/textures/Bricks076_1K-JPG.zip
```

## Constraints + Guidelines

- **Follow HTTP redirects:** The `ambientcg.com/get` endpoint issues an HTTP 302 redirect to Backblaze B2 storage. Always use `curl -L` when downloading.
- **Select OpenGL normals:** ambientCG ZIP bundles typically include both `_NormalGL.jpg` and `_NormalDX.jpg`. Always extract and use `_NormalGL.jpg`; Roblox's normal shader expects OpenGL coordinates.
- **Prefer 1K-JPG:** Use `1K-JPG` for standard game assets to keep file sizes and memory consumption low. Reserve `1K-PNG` for assets requiring crisp, lossless transparency or alpha cutouts.
- **Archive cleanup:** Delete the downloaded `.zip` file after extracting maps to keep the thread scratchpad uncluttered.

## Limitations

- **ZIP requirement:** ambientCG does not offer direct HTTP links to loose individual image files; maps must be extracted from the archive before loading into Blender.
- **API rate etiquette:** While public and free of authentication keys, automated queries should avoid rapid burst requests against the endpoint.

## References

- [ambientCG Documentation](https://docs.ambientcg.com/): Official API reference, query parameters, and endpoints.
- [ambientCG License](https://docs.ambientcg.com/license/): CC0 public domain terms.
- [ambientCG Web Gallery](https://ambientcg.com/): Interactive browser for visual exploration.
