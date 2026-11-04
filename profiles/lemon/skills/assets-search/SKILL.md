---
name: assets-search
description: Search and evaluate Roblox Creator Store assets for a game project. Use when someone asks Lemon to find or compare models, sounds, images or other assets.
---

# Search for assets

## Search

Understand what the group needs and check relevant project documentation for its style and decisions. Search the Creator Store with Roblox Assets MCP's `search_assets`, choosing the category that fits the request. Searches default to free models; use another category when appropriate and include paid results only if the group wants to consider them.

Search with useful variations and inspect more results when the first page does not provide suitable options. For promising candidates, use `get_asset_details` to check their metadata and thumbnail. A thumbnail may still be pending or unavailable.

Models, MeshParts, Decals, Plugins and Videos can have useful visual thumbnails; a video preview is a still frame. FontFamily thumbnails are wide, often transparent samples, and audio thumbnails do not let someone hear the sound. An unavailable or blank preview for one listing does not establish that the entire category lacks previews.

Video delivery can return a streaming manifest rather than a video file; if its segments are inaccessible, say what failed and offer the thumbnail and listing instead. Audio duration may be present in the listing description even when there is no dedicated duration field.

Do not search or inspect Place assets through Roblox Assets MCP; explain that this integration does not support the request. For other categories, if a search or page request fails, report the actual error and try another relevant query when useful. Some pagination requests returned HTTP 400 during testing, but that does not establish that every page request will fail.

| Tool | Purpose |
|---|---|
| `search_assets` | Find listings by words, category and price, with pagination. |
| `get_asset_details` | Inspect one listing's metadata and thumbnail. |
| `prepare_asset_download` | Get a temporary download URL for a selected asset. |

## Evaluate

Compare candidates against the request and the game's style. Check the creator, price, availability and script information when Roblox provides them. A missing field is unknown, not evidence that an asset is free, safe or script-free. A thumbnail does not prove how an asset looks or behaves in the game.

Shortlist suitable options and explain their differences and your recommendation. If appearance, sound or another creative choice matters, ask the group to choose before importing. Use the `assets-answering` skill to present the options.

## Inspect

When the group chooses an asset or asks for a closer inspection, `prepare_asset_download` returns a temporary URL; it does not download or inspect the file. Fetch it into the thread's scratchpad, inspect what your tools can actually read, and keep the URL out of chat. Check contents, scripts, permissions and suitability as far as the available tools allow before importing. Never execute scripts from an asset to inspect it.

If you cannot inspect a model or confirm its behavior, permissions or suitability, say what remains unknown and arrange a Studio check with the group. Do not claim an asset is safe, usable or tested without evidence.
