---
name: assets-search
description: Use when someone asks to find or compare Roblox assets.
---

# Search for assets

## Search

Find out what the group needs and check relevant project documentation for its style and decisions. Search the Creator Store with Roblox Assets MCP. Try useful variations when the first results don't fit, and use the category that matches the request. Searches default to free models; include paid results only if the group wants to consider them.

| Category | What you can find | Example |
|---|---|---|
| `Model` | Objects or groups of parts, sometimes with scripts | A forest cabin |
| `MeshPart` | Individual 3D meshes | A rock or fence mesh |
| `Decal` | Images for surfaces | A warning sign |
| `Audio` | Sound effects and music | Footsteps or a car horn |
| `Video` | Videos for in-game screens | TV static |
| `Plugin` | Tools for Roblox Studio | A building tool |
| `FontFamily` | Fonts for interface text | A serif font for a menu |

| Tool | What it does |
|---|---|
| `search_assets` | Search listings by words, category and price, with pagination. |
| `get_asset_details` | Check one asset's metadata and thumbnail. |
| `prepare_asset_download` | Get a temporary URL for an asset file. |

## Evaluate

Compare the options with what the group wants and the game's style. Check who made each asset, its price, availability and whether it contains scripts when that information is available. If something is missing, don't assume the asset is free, safe or script-free.

Models, meshes, decals, plugins and videos can have useful previews, but a video preview is only a still frame. Font samples are wide and often transparent. An audio thumbnail doesn't let someone hear the sound, and its duration may only appear in the description. Use the asset presentation skill to show the options.

Explain the differences and let the group decide when a creative choice matters. A picture or description alone doesn't show how an asset will look or behave in the game.

## Inspect

When the group chooses an asset or asks to inspect it more closely, get a temporary download link and save the file in the thread's scratchpad. For sounds, follow the asset presentation skill to download and attach the options before the group chooses. Keep temporary download links out of chat.

Check the asset's contents, scripts, permissions and suitability as far as your tools allow. Don't run its scripts just to inspect them. If you can't confirm something, explain what remains unknown and arrange a check in Studio with the group.

## Limitations

- **Places:** Don't search or inspect Place assets through Roblox Assets MCP. If asked, explain that this integration doesn't support the request; Places may still be available elsewhere on Roblox.
- **Video files:** Delivery can return a streaming manifest rather than a video file. If its segments are inaccessible, explain what failed and offer the thumbnail and listing instead.
- **Search errors:** If a search or page request fails, report the actual error and try another relevant query when useful. Some pagination requests returned HTTP 400 during testing, but that doesn't mean every page request will fail.

## Common pitfalls

- **Missing previews:** A thumbnail can be pending, blank or unavailable. One missing preview doesn't mean the whole category lacks them.
- **Overstating results:** A listing's name, description or thumbnail isn't proof that an asset works, is safe to import or fits the game. Say what still needs checking in Studio.
- **Temporary URLs:** A download URL isn't the file itself and can expire. Fetch the file in your workspace and share the public listing link instead of the temporary URL.

## References

- [Roblox Creator Store API](https://create.roblox.com/docs/cloud/reference/features/creator-store): Search and asset metadata.
- [roblox-assets-mcp](https://github.com/Petri-Hub/roblox-assets-mcp): The MCP server used to find and inspect assets.
