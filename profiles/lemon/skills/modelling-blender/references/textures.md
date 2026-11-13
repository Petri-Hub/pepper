# Texture sources and portable materials

Read this when a model needs image textures, especially wood, stone, metal, fabric or other surfaces. A Blender base color or generated shader may look right in a render and still disappear in Roblox. A texture is an image; UV coordinates tell the mesh where that image goes. Inspect both the texture and its placement on the actual model.

## Find usable images

Start with the project's existing assets and its license/provenance records. For new textures:

| Source | Good for | What to check |
|---|---|---|
| [Poly Haven](https://polyhaven.com/textures) | Real PBR material sets and an [official API](https://api.polyhaven.com/) suited to tools and agents. | Its assets are CC0; read the [asset license](https://polyhaven.com/license) and current API terms. |
| [ambientCG](https://ambientcg.com/) | Tileable materials, often with multiple PBR maps and an [API](https://docs.ambientcg.com/api/). | Its asset files are [CC0](https://docs.ambientcg.com/license/); check download size, map type and current API terms. |
| [Unsplash](https://unsplash.com/) | Individual photographs that can supply a color image, especially when a specific photographic look is requested. | Choose a **free Unsplash License** photo, not an Unsplash+ image unless authorized. Check its [license](https://unsplash.com/license), site/API terms and depicted rights. A photo is not automatically seamless, evenly lit or a complete PBR set. |

When using Unsplash, search descriptions such as `weathered wood planks texture` or `stone wall texture`; open the individual photo page, check that it is free, identify the photographer, inspect the full surface, and obtain the image through an allowed download or API workflow. Avoid people, logos and other recognizable protected content unless the necessary rights are established. A search result or thumbnail is not a license or an original texture file. If a source needs credentials or its terms prohibit the intended automated access, don't bypass it; use an allowed source or ask for a permitted alternative.

Preserve the original image, photo page/asset URL, creator, license, retrieval date and any transformations in the scratchpad or the project's asset provenance file. Follow project rules for including third-party images in Git or distributing assets. For materials intended for public distribution, verify that the license covers the actual use and redistribution; don't assume free means unrestricted.

Use a source whose artistic direction fits the group. For broad walls or floors prefer consistent lighting, a straight-on view, enough resolution and a repeatable surface; obvious shadows and perspective in a photo will be baked into the image and can look wrong across a large scene. Resize or crop as needed, but record the transformation. Tileable textures and trim sheets can save work; inspect visible seams, repetition and texel density rather than assuming an image tiles.

## Connect image maps in Blender

For the baseline tested path, save each real image to its own distinct file path, load it as an Image Texture, and connect **Color → Principled BSDF → Base Color**. Ensure every image-bearing mesh has UVs and the intended material, with one material per export mesh or a baked atlas. Save/pack images into the `.blend` and embed them in the FBX. Merely changing `diffuse_color` or an unconnected shader constant did not preserve the sword's distinct colors in our tested upload.

```python
import bpy

image = bpy.data.images.load("/absolute/scratch/wood.jpg", check_existing=True)
image.pack()
material = bpy.data.materials.new("Wood")
material.use_nodes = True
nodes = material.node_tree.nodes
image_node = nodes.new("ShaderNodeTexImage")
image_node.image = image
material.node_tree.links.new(
    image_node.outputs["Color"], nodes["Principled BSDF"].inputs["Base Color"]
)
# Assign material to the UV-mapped mesh, then export using the Blender and FBX checks.
```

For generated or baked maps, write **each image to a unique, real filename**, then pack and embed it; do not leave multiple images on the same unnamed or shared path. We saw Blender reimport report packed images while Roblox assigned a texture only to one mesh. Giving the images distinct paths and exporting again yielded texture references on every intended greatsword mesh. The check is per material and per exported object, including glass, trim and dark inserts—not a single count of images.

## Understand the Roblox result

- `MeshPart.TextureContent`/`TextureID` is a basic color texture. `SurfaceAppearance` provides PBR maps, including color, normal, roughness and metalness. Which embedded maps Open Cloud preserves must be checked on the returned model and in Studio; a basic image reference does not prove PBR survived.
- Roblox says most `SurfaceAppearance` map properties cannot be changed by ordinary scripts at runtime. Do not promise to create a fully configured PBR appearance by setting its map properties in a LocalScript; use a supported preconfigured authoring/import path and validate it. Built-in `MeshPart.Color`/`Material` can be useful for simple parts, but are not a substitute when the group requested a specific image texture.
- For normal/roughness/metalness image maps, use appropriate non-color data and Roblox's documented node connections. An Unsplash color photo doesn't provide physically accurate normal or roughness data. Texture and lighting results differ between Blender and Roblox and among devices.
- Image/mesh dependencies can have their own moderation and permissions. The API returning an approved parent model doesn't prove every texture will render for the target experience. Inspect every resulting reference and ask the group to check it in Studio.
- Roblox currently documents up to 4096×4096 for general textures; the Open Cloud image-upload file-size/dimension restrictions are separate. Select a sensible resolution for on-screen size and memory, not simply the largest image. Consult current [texture specifications](https://create.roblox.com/docs/art/modeling/texture-specifications) and [PBR documentation](https://create.roblox.com/docs/art/modeling/surface-appearance).

Our Unsplash cabin test embedded actual wood and stone photographs; the downloaded Roblox Model contained the two expected image IDs on its 57 textured MeshParts, and a person confirmed the house looked close to the Blender model in Studio. That is one successful basic-color test, not a guarantee for all textures, PBR maps, permissions or future API behavior.
