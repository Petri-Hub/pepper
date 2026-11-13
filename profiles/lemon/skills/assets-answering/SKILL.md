---
name: assets-answering
description: Use when showing the group asset options to pick from.
---

# Present assets

## Message and examples

In Discord, give each option a letter and a **bold linked name**, followed by a short description and why someone might choose it. Keep the same order and letters in the message and attachments. For audio, include a known duration in the same bold text as the name. Don't include a separate asset ID unless asked.

Mention the price when known, explain meaningful differences and recommend options when you have a reason. Use the person's request and the game's established style to guide your choices. Don't invent a reason to recommend something when the context doesn't support one. Ask the group to choose when the decision matters to the game's look, sound or direction.

### Examples

Use these examples for formatting, not as scripts. Adapt your descriptions to what you have actually checked.

**Visual assets:**

> Separei algumas estantes que podem combinar com um jogo de terror. As imagens estão etiquetadas com a letra de cada uma.
>
> **A — [Bookshelves](https://create.roblox.com/store/asset/141047988)**
> Estilo clássico do Roblox, com madeira grossa e livros coloridos. Combina com um visual mais blocoso.
>
> **B — [Medieval Bookshelf](https://create.roblox.com/store/asset/834958293)**
> Madeira escura com acabamento rústico. Eu escolheria esta para uma cabana antiga ou uma loja de madeira velha.

**Audio:**

> Separei um som para vocês ouvirem:
>
> **A — [Choral Wind Eerie Vocal Whisper Wind Ghosts](https://create.roblox.com/store/asset/9125440141) · 0:18**
> Sopro com vozes para uma cena de suspense.

## Gallery

For visual assets, build one gallery from the thumbnails downloaded into the thread's scratchpad. Use it even for a single option. Models, MeshParts, Decals, Plugins and Videos can have useful previews; a video thumbnail is a still frame.

```sh
lemon-asset-gallery gallery.png \
  --item A "Sword katana" thumbnail-a.png \
  --item B "Medieval Bookshelf" thumbnail-b.png \
  --favorite B
```

| Option | Use |
|---|---|
| `--item A "Name" thumbnail.png` | Add an option with its letter, name and thumbnail path. Repeat for each option. |
| `--item A "Name" -` | Show a no-preview card when the thumbnail is unavailable or known to be a placeholder. |
| `--favorite A` | Mark an option as “Favorita do Lemon”. Repeat for multiple choices; order stays the same. |
| `--fonts` | Show all options as a vertical list of font samples. |
| `--font A` | Show one font on a dark card in a mixed gallery. Repeat for other fonts. |

Use real paths and a new output filename: the helper won't overwrite a file. It accepts up to eight items. For more, make separate galleries and send each in its own message so Discord doesn't crop multiple attachments. Check that the gallery was delivered. If the helper or attachment fails, say so and use labeled text and listing links.

## Fonts

Font previews are wide samples of text, often white on a transparent background. Download the thumbnail from the asset details. The gallery gives fonts a dark background and keeps the letters in proportion.

```sh
# When every option is a font, show the samples in a vertical list.
lemon-asset-gallery fonts.png --fonts \
  --item A "PT Serif" pt-serif.png \
  --item B "Nanum Gothic" nanum-gothic.png
```

```sh
# When fonts are mixed with other assets, identify each font by its letter.
lemon-asset-gallery mixed.png \
  --item A "PT Serif" pt-serif.png \
  --item B "Bookshelves" bookshelves.png \
  --font A
```

If a sample is too small or unavailable, say so and link the listing.

## Audio

Send playable audio files as attachments. Get a temporary link for each candidate with prepare_asset_download and download the file into the thread's scratchpad. If a file is compressed, decompress it and give it the correct audio extension. Use ffprobe to check the file and its duration.

Give each file a distinct letter and include its absolute sandbox path in a MEDIA: directive. Check that the attachment was delivered, and keep temporary download URLs out of chat.

If a file can't be retrieved, played or attached, say which option is unavailable and provide its public listing link. Omit the duration when it's unknown; don't claim to have heard a sound unless you checked it.

## Limitations

- **Places:** Roblox Assets MCP cannot search or inspect Place assets. If asked to find Places, explain that this integration doesn't support the request and don't attempt a Place search through it. Places may still be available elsewhere on Roblox.

## Common pitfalls

- **Unverified previews:** A thumbnail can be blank, unavailable or a placeholder. It doesn't prove an asset is safe or works in the game; inspect the chosen asset before importing it.
- **Misleading media:** A video thumbnail is a still frame, and an audio thumbnail doesn't let anyone hear the sound. A name or description alone doesn't prove how a sound plays.
- **Missing attachments:** Check that the gallery or audio files were delivered, and report failures instead of claiming they were sent.
- **Missing information:** Unknown prices, scripts, permissions and durations aren't evidence that an asset is free, script-free, usable or a particular length.

## References

- [Roblox Creator Store API](https://create.roblox.com/docs/cloud/reference/features/creator-store): Search and asset metadata.
- [roblox-assets-mcp](https://github.com/Petri-Hub/roblox-assets-mcp): The MCP server used to find and inspect assets.
