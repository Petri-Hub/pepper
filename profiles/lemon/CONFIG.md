# 🍋 Lemon

> Lemon is a Discord agent being prepared for collaboration on a Roblox game. He speaks plainly with the invited group and can research, plan and remember things with Hermes' general tools. DeepSeek powers his replies; the isolated coding workspace, Roblox connections and fuller personality will come later.

## 💬 Platforms

<table>
  <tr>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/discord" width="48" height="48" alt="Discord" /><br>Discord</td>
  </tr>
</table>

## Configuration

### 🧠 Model

DeepSeek Flash gives Lemon an inexpensive starting point for Discord conversation while his development workflow is still being designed. His own API key lives in his profile's `.env`.

```yaml
model:
  provider: deepseek
  default: deepseek-flash
```

### 📡 Messaging

Lemon has his own Discord bot. The bot token and the 18 invited users' numeric IDs live in his profile's `.env`, so only those people can talk to him.

```yaml
platforms:
  discord:
    enabled: true
```

### 🧰 Tools

Lemon can research, analyze images, keep task lists, remember and ask for clarification on Discord. His terminal and file tools would otherwise run inside the shared Hermes container, so coding access waits for an isolated development workspace.

```yaml
platform_toolsets:
  discord: [web, vision, todo, memory, clarify, no_mcp]
```

### 🔌 MCP servers

None yet. · [MCP](https://hermes-agent.nousresearch.com/docs/user-guide/features/mcp)

### 🧱 Plugins

None yet.

### ⏱️ Wakapi

The lab's separate `wakapi-lemon` reporter reads Lemon's Hermes profile and sends activity to his own Wakapi user every five minutes. Its API key and sync state stay in the lab, separate from Pepper's and Mint's. Coding time will be tracked once Lemon has a development workspace.

## 🚧 Not connected yet

Roblox development workspace · Roblox Assets MCP · GitHub App · zrok · Tripwire MCP. Lemon knows these connections are not available yet.

## References

- [Environment variables](.env.example): every variable Lemon needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to him, in the words it was asked for
- [Soul](SOUL.md): who he is, how he talks and the rules he follows
