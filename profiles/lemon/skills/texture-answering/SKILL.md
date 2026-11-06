---
name: texture-answering
description: Present texture and material options to the Discord group with visual previews, PBR map specifications, and license details. Use when showing the group candidates or asking them to choose a texture.
---

# Present textures and materials

## Message format

In Discord, give each texture option a distinct letter (A, B, C) and a **bold linked name**, followed by the source platform, license, and a brief description of the surface. Explain why someone might choose it for the model or environment, and recommend an option when you have a clear stylistic reason.

Keep the same order and letters in your message and in the attached gallery image. When presenting options, clarify whether the texture is a full PBR set (Color, Normal, Roughness) or a diffuse-only photo, and whether it tiles seamlessly.

### Example presentation

Use this example for formatting and friendly collaborative tone, adapting the text to what you have actually inspected:

> Separei algumas opções de textura de madeira para a mesa da taverna. As prévias estão etiquetadas na galeria abaixo:
>
> **A — [Wood Table 001](https://polyhaven.com/a/wood_table_001) · Poly Haven (CC0)**
> Madeira polida com acabamento envernizado e reflexos suaves. Minha recomendação se vocês quiserem um móvel nobre e bem cuidado.
>
> **B — [Wood 049](https://ambientcg.com/a/Wood049) · ambientCG (CC0)**
> Tábuas envelhecidas e rústicas com ranhuras profundas e aspecto fosco. Combina bastante se o clima for de uma taverna antiga ou abandonada.
>
> Qual dessas combina mais com o que vocês imaginaram?

## Gallery preview

Build one composite preview card from the texture thumbnails downloaded into the thread's scratchpad. Use `lemon-asset-gallery` so collaborators on mobile or Discord can compare the surfaces at a glance without opening external browser links.

Download or generate each thumbnail from the source URL returned by its API into this thread’s scratchpad. Verify the response is an image; if it is unavailable, pass `-` for a no-preview card.

```sh
# Generate a labeled comparison gallery card using the sandbox helper

lemon-asset-gallery /home/lemon/workspace/scratchpad/textures/gallery.png \
  --item A "Wood Table 001" /home/lemon/workspace/scratchpad/textures/thumb_a.png \
  --item B "Wood 049" /home/lemon/workspace/scratchpad/textures/thumb_b.png \
  --favorite A
```

| Option | Use |
|---|---|
| `--item A "Name" thumbnail.png` | Add a texture option with its letter, name, and downloaded thumbnail image. |
| `--favorite A` | Mark an option as “Favorita do Lemon” with a badge when you recommend it. |

Include the gallery in your reply using the sandbox attachment directive:

```text
MEDIA:/home/lemon/workspace/scratchpad/textures/gallery.png
```

## Constraints + Guidelines

- **Consistent lettering:** Ensure that letter A in the gallery image matches option A in the text description.
- **Accurate licensing:** Always state the license (e.g. `CC0`) and link to the source page so collaborators can verify provenance.
- **Surface traits:** Mention the physical feel of the material: is it rough, glossy, weathered, metallic, or smooth?
- **Delivery verification:** Verify that `lemon-asset-gallery` exited successfully and the generated image exists before referencing it in your reply.

## Limitations

- **2D thumbnail limits:** A flat 2D preview shows the base color pattern, but cannot show how 3D normal bumps or roughness reflections react to dynamic lighting in Roblox Studio. Remind the group that final judgment happens in the Studio preview.
- **Gallery item cap:** `lemon-asset-gallery` accepts up to eight items per gallery. For more than eight choices, narrow down to the top candidates or create separate galleries.

## References

- [assets-answering](../assets-answering/SKILL.md): Lemon's general asset presentation skill.
- [lemon-asset-gallery](https://github.com/Petri-Hub/lab/tree/main/sandboxes/lemon-sandbox): Helper utility for building Discord preview galleries.
- [Roblox SurfaceAppearance](https://create.roblox.com/docs/art/modeling/surface-appearance): PBR material documentation for Roblox.
