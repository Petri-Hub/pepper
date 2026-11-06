# Roblox upload, delivery and preview

Read this when the agreed task includes making an asset usable in Roblox. An FBX is uploaded through the **Open Cloud Assets API**, not by listing it on the Creator Store. Roblox creates a cloud Model/package with MeshParts and dependencies; Rojo uses the resulting Roblox model data, not the FBX itself. Do not put API keys or signed CDN URLs into files, terminal output, chat, source control or the game. Do not use an unrelated key just because it exists.

## Upload prerequisites

Confirm the approved creator (user or group) and numeric ID, target game/experience when relevant, source/license and the exact file. A user-owned upload can be created without supplying a game or place. If group-owned, the key owner needs the appropriate group role. Creator and experience permissions are separate: a creator's access doesn't prove the game can load every dependent mesh and image.

The actual upload identity needs `asset:read` and `asset:write` or the equivalent Assets Read/Write API-key permissions. Asset-permission grants have a separate scope; don't request it unless the workflow needs a grant. Public Creator Store distribution and place publication are separate actions and are not required for a private preview. The existing `roblox-assets` MCP currently supplies search, details and `prepare_asset_download`, not upload; check available tools rather than inventing upload methods. If a write-capable MCP is installed in the future, inspect its schema and use the configured authorized identity.

If an authorized asset-write key is unavailable in Lemon's execution environment, stop here and tell the group what is missing. Do not ask them to paste a secret into Discord, access 1Password, write it into the repository, or reuse an ingestion, test-place or MCP read key without verifying scope and authorization. A locally configured secret injected by the operator is a deployment concern, not a reason to put real values in a skill.

## Create and poll

Roblox documents one asset per request and a 20 MB file limit for this API's model upload. Supported Model formats include `.fbx`, `.gltf`, `.glb`, `.rbxm` and `.rbxmx`. Upload Blender FBX/GLB as **Model**, not as a raw Mesh: raw Mesh upload only accepts Roblox mesh data from Asset Delivery. Model uploads may contain multiple MeshParts and become packages. Roblox notes that `.rbxm` files edited outside Studio might not upload or work. Model content updates currently support FBX; image content isn't updateable. Check the [current Assets usage guide](https://create.roblox.com/docs/cloud/guides/usage-assets) before depending on those limits.

For a direct API request, use a supported client or a narrowly scoped script that reads an injected secret without printing it. Conceptually the multipart request contains:

```text
POST https://apis.roblox.com/assets/v1/assets
x-api-key: <provided through the client's secret handling>
request: {"assetType":"Model", "displayName":"...", "description":"...",
          "creationContext":{"creator":{"userId":"<creator-id>"}}}
fileContent: asset.fbx   Content-Type: model/fbx
```

Use `groupId` in place of `userId` for an approved group owner. Let the HTTP client construct the multipart boundary. Never print request headers, use shell tracing, paste a token into a command, or embed it in a `curl` argument visible to other processes. Redact API errors if they include request details. Store the operation ID and metadata, not the secret.

For example, the following **Bash** commands upload an FBX owned by the approved user. They assume the operator has already injected `ROBLOX_ASSETS_WRITE_KEY` into the process environment, and that `curl` and `jq` are available. Set the non-secret paths and ID for this task; use a group-owned request only after selecting the group and changing the JSON creator key. Run with shell tracing disabled. The key is fed to curl's config on standard input, rather than as a command argument. Treat the response as potentially sensitive and inspect it before sharing or storing it.

```bash
set +x
: "${ROBLOX_ASSETS_WRITE_KEY:?Asset-write key is not configured}"
asset_file="/absolute/scratch/asset.fbx"
creator_id="<approved-user-id>"
request=$(jq -nc --arg id "$creator_id" \
  '{assetType:"Model", displayName:"Example asset", description:"",
    creationContext:{creator:{userId:$id}}}')

printf 'header = "x-api-key: %s"\n' "$ROBLOX_ASSETS_WRITE_KEY" |
  curl --silent --show-error --fail --config - \
    --form-string "request=$request" \
    --form "fileContent=@${asset_file};type=model/fbx" \
    https://apis.roblox.com/assets/v1/assets
```

Record the returned operation ID immediately. To poll it, set `operation_id` to the returned non-secret ID and use the same private header mechanism:

```bash
operation_id="<returned-operation-id>"
printf 'header = "x-api-key: %s"\n' "$ROBLOX_ASSETS_WRITE_KEY" |
  curl --silent --show-error --fail --config - \
    "https://apis.roblox.com/assets/v1/operations/${operation_id}"
```

These commands show one request each; apply the polling and retry rules below. Do not put a real key in them. If the process is interrupted before recording the response, the upload outcome is unknown; investigate before creating a duplicate.

The response contains `operations/<operationId>`. Poll `GET https://apis.roblox.com/assets/v1/operations/<operationId>` with the same authorized identity using a modest interval (for example 5 seconds), a timeout, and bounded backoff for 429/transient errors. Report terminal failures; do not blindly retry a create request when a timeout leaves its result unknown, because it may create a duplicate. Resume polling a known operation rather than uploading again. Capture the returned asset ID, revision, owner, moderation state, operation completion and timing. A timeout means **pending/unknown**, not failed or ready; continue other work rather than blocking indefinitely.

Our test uploads completed with `Approved` on polls around 6–22 seconds, including a photo-textured cabin around 16 seconds. These are observations of a few small assets, not an SLA, not an exact approval time, and not proof that dependent textures load. Roblox says moderation generally occurs within a few hours; while queued, users of a published game can't see or interact with an asset. Report pending, rejected and unknown states honestly. See [asset moderation](https://create.roblox.com/docs/projects/assets).

## Download and inspect the Roblox result

After the operation reports a Model asset ID, call `prepare_asset_download` when the configured MCP identity has delivery access, or use an authorized [Asset Delivery API](https://create.roblox.com/docs/cloud/reference/features/assets). Download its temporary URL promptly into this thread's scratchpad. The URL is a bearer-like short-lived link: do not paste it into chat, a tracked file, logs or a command argument. Do not assume a successful search, free listing, thumbnail, public-looking ID or another key's access grants the target experience access.

Inspect the bytes instead of trusting a filename: the download may be gzip-compressed; decompress only when the gzip signature is present and retain the actual Roblox model bytes. A Model/package ID is not necessarily a `MeshPart.MeshId`. Do not re-upload someone else's restricted assets to bypass access controls.

Build an isolated inspection project with Rojo and, when useful, output `.rbxlx` so an XML parser can list **every** model child, MeshPart, mesh content ID, texture content ID and `SurfaceAppearance`. Names and property strings can be deduplicated in binary `.rbxm`; a binary string search for `MeshPart` is not a valid instance count. Compare against the actual export: number of pieces, names, dimensions, paths for each intended texture, and, where relevant, map IDs and owner/access. A reference existing is not proof the image, PBR processing or dependency permissions work in Studio. Inspect failures before re-uploading; use the latest validated file and avoid creating a new asset for every speculative fix.

In our tests: the original sword arrived with gray parts and no texture references; an FBX with UV-mapped, embedded images produced distinct texture IDs; the Unsplash cabin's 58 MeshParts retained the intended two photographic color maps on 57 pieces, and the remaining window was intentionally untextured. These are observations, not guarantees for different material graphs or PBR maps.

## Rojo and client/server placement

The project already maps `.rbxm` files under `src/assets/` using `$path` in `default.project.json` (and, where needed, the test project). Follow the project's existing server/client asset placement. For example:

```json
{
  "ReplicatedStorage": {
    "ExampleModel": { "$path": "src/assets/ExampleModel.rbxm" }
  }
}
```

This is only the relevant part of a Rojo tree, not a complete project. The instance must then be placed or cloned into `Workspace` by appropriate Luau or be mapped there directly. A `LocalScript` preview only creates its copy on that client; shared gameplay, damage, collision and authority belong on the server as required by the game. Set `Anchored`, `CanCollide` and interaction intentionally: our visual gallery disabled collisions and is not evidence that models cannot collide. Check bounding boxes against a character, pivot and ground contact. Imported mesh collisions may be approximate, especially near doors and holes; test them rather than making every decorative surface expensive.

If an export is 100× too large, investigate Blender units and `FBX_SCALE_UNITS` first. `Model:ScaleTo(0.01)` was a temporary preview correction, not a universal conversion rule: a correctly exported asset would become tiny. Roblox may load the current asset version and dependencies separately; keep source and IDs traceable. An alternative runtime `AssetService:LoadAssetAsync(assetId)` needs Roblox access and error handling and may load a newer version; don't assume every package or permission combination works without a test.

Run `rojo build` and the project's appropriate format/lint/build checks. This establishes parse/build success only; Rojo live sync may have mesh-property limitations and cannot prove visuals. Use the `serve` skill for the thread's own Rojo Share server and provide its **ready Studio URL**, expiry and instructions. A clean Baseplate place avoids leftovers from another preview; Rojo doesn't necessarily delete instances outside its managed tree. Tell the group to press **Play** if a client/server script creates the model at runtime, then inspect shape, size, orientation, textures, Output and relevant collisions in Studio and, when relevant, the actual published experience. If the sandbox cannot run Studio, say so and wait for the human's observation before marking that check passed.

Useful references: [Open Cloud Assets API](https://create.roblox.com/docs/cloud/reference/features/assets), [asset privacy](https://create.roblox.com/docs/projects/assets/privacy), [Roblox mesh and collision](https://create.roblox.com/docs/parts/meshes), [Rojo sync details](https://rojo.space/docs/v7/sync-details/), and the project's `serve` and `test` skills.
