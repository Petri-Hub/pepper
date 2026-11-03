---
name: assets-answering
description: Present Roblox asset search results in Discord with labeled preview images and clear text. Use when showing the group candidates or asking them to choose an asset.
---

# Present assets

## Options

Use the candidates and evidence from `assets-search`. Pick a small set that fits the request, explain the meaningful differences and recommend one when you have a reason. Say when a thumbnail, price, script information or other detail is unavailable; do not present missing information as a fact.

## Images

Give each visual candidate a short label, such as `A`, `B` or `C`. Put that label and the asset ID directly on its preview image so the group can match the image to the text. Keep each asset's identity attached to its own image. Use `lemon-label-preview` on a downloaded thumbnail from the thread's scratchpad:

```sh
# Add an option label and asset ID to a thumbnail.
lemon-label-preview thumbnail.png labeled.png --label A --asset-id 123456
```

Use the actual input and output paths. The helper runs in the sandbox and will not overwrite an existing output file. Attach each labeled image in Discord and check that it was delivered. If the helper, thumbnail or attachment is unavailable, say so and use numbered text and listing links instead. Do not invent a preview or claim an image was sent when it was not.

## Message

Keep the message readable in Discord without tables. For each option, include the matching label, asset name, ID, creator, listing link and a brief reason to consider it. Mention the price when known and any relevant uncertainty, such as scripts or permissions that still need checking. For sounds or other nonvisual assets, provide the listing link and describe only what you have verified.

Ask the group to choose when the difference matters to the game's look, sound or direction. Use public listing links, not temporary asset download URLs. A selected asset still needs inspection before it is imported.
