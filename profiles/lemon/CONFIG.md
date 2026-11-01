# 🍋 Lemon

> Lemon is a Discord agent being prepared for collaboration on a Roblox game. He speaks plainly with the invited group, can research, plan and remember things with Hermes' general tools, and codes in his own workspace over SSH. DeepSeek powers his replies; the Roblox connections and fuller personality will come later.

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

Lemon can research, analyze images, keep task lists, remember, ask for clarification, use Roblox Assets MCP and run commands in his own workspace on Discord.

```yaml
platform_toolsets:
  discord: [web, vision, todo, memory, clarify, roblox-assets, terminal]
```

### 🖥️ Workspace

His commands run in a container of their own in the lab, not in the one Hermes shares with every profile. The lab starts his image as `lemon-sandbox` on the Docker network, publishing no port, and Hermes reaches it over SSH with a key that belongs to him. Commands start in `/home/lemon/workspace`, where the game's repository is checked out; only the `lemon` user can log in, and only with that key.

```yaml
terminal:
  backend: ssh
  ssh_host: lemon-sandbox
  ssh_user: lemon
  ssh_key: /opt/data/profiles/lemon/ssh/lemon_sandbox_ed25519
  cwd: /home/lemon/workspace
```

The private key lives in his profile directory, never in this repository, and the public half sits in the lab's `authorized_keys`. The workspace and the container's SSH host key are on the lab's persistent storage, and the lab backs both up every six hours.

### 🔌 MCP servers

Roblox Assets MCP lets Lemon search Creator Store listings, inspect asset metadata and request temporary download links. The server runs in his Hermes profile with its own Roblox Open Cloud key. Assets can be fetched into his workspace; getting them into the game still needs a Studio session or an Open Cloud path he does not have yet.

| Server | What it gives the agent | Link |
|---|---|---|
| `roblox-assets` | Creator Store search, details and temporary asset URLs | [Roblox Assets MCP](https://github.com/Petri-Hub/roblox-assets-mcp) |

```yaml
mcp_servers:
  roblox-assets:
    command: uvx
    args: [roblox-assets-mcp]
    env:
      ROBLOX_API_KEY: "${ROBLOX_API_KEY}"
```

### 🧱 Plugins

None yet.

### ⏱️ Wakapi

The lab's separate `wakapi-lemon` reporter reads Lemon's Hermes profile and sends activity to his own Wakapi user every five minutes. Its API key and sync state stay in the lab, separate from Pepper's and Mint's.

## 🚧 Not connected yet

GitHub App · zrok · Tripwire MCP. Lemon knows these connections are not available yet.

## References

- [Environment variables](.env.example): every variable Lemon needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to him, in the words it was asked for
- [Soul](SOUL.md): who he is, how he talks and the rules he follows
- [Lemon sandbox](https://github.com/Petri-Hub/lab/tree/main/sandboxes/lemon-sandbox): the container his commands run in, in the lab
