---
name: assets-search
description: Search and evaluate Roblox Creator Store assets for a game project. Use when someone asks Lemon to find or compare models, sounds, images or other assets.
---

# Search for assets

## Search

Understand what the group needs and check relevant project documentation for its style and decisions. Search the Creator Store with Roblox Assets MCP's `search_assets`, choosing the category that fits the request. Searches default to free models; use another category when appropriate and include paid results only if the group wants to consider them.

Search with useful variations and inspect more results when the first page does not provide suitable options. For promising candidates, use `get_asset_details` to check their metadata and thumbnail. A thumbnail may still be pending or unavailable.

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
